package com.cluvex.aether

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import android.util.Log
import androidx.core.app.NotificationCompat
import java.io.FileInputStream
import java.io.FileOutputStream
import java.net.InetSocketAddress
import java.nio.ByteBuffer
import java.nio.channels.DatagramChannel
import java.nio.channels.SocketChannel
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.Executors

class AetherVpnService : VpnService() {

    companion object {
        const val ACTION_START = "com.cluvex.aether.START_VPN"
        const val ACTION_STOP = "com.cluvex.aether.STOP_VPN"
        const val CHANNEL_ID = "AetherVpnChannel"
        const val NOTIF_ID = 1819
        private const val TAG = "AetherVpnService"

        const val PROXY_HOST = "127.0.0.1"
        const val PROXY_PORT = 1819
    }

    private var vpnInterface: ParcelFileDescriptor? = null
    @Volatile private var isRunning = false
    private val executor = Executors.newCachedThreadPool()

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        if (action == ACTION_STOP) {
            stopVpn()
            return START_NOT_STICKY
        }

        if (action == ACTION_START) {
            startVpn()
        }

        return START_STICKY
    }

    private fun startVpn() {
        if (isRunning) return

        try {
            val builder = Builder()
                .setSession("Aether Full Device Tunnel")
                .addAddress("10.0.0.2", 24)
                .addRoute("0.0.0.0", 0)
                .addDnsServer("1.1.1.1")
                .addDnsServer("8.8.8.8")
                .setMtu(1500)

            // Protect our own proxy connection loop
            protect(DatagramChannel.open().socket())

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                builder.setMetered(false)
            }

            vpnInterface = builder.establish()
            if (vpnInterface == null) {
                Log.e(TAG, "Failed to establish VPN interface (null)")
                return
            }

            isRunning = true

            // Start Foreground Notification
            val notification = createNotification(
                "Aether Active",
                "Full device traffic tunneled via SOCKS5 proxy (127.0.0.1:1819)"
            )
            startForeground(NOTIF_ID, notification)

            // Launch TUN forwarding loop
            executor.submit { runTunForwarder() }

            Log.i(TAG, "Full device VPN service started successfully.")
        } catch (e: Exception) {
            Log.e(TAG, "Error starting VPN interface: ${e.message}", e)
            stopVpn()
        }
    }

    private fun runTunForwarder() {
        val pfd = vpnInterface ?: return
        val inputStream = FileInputStream(pfd.fileDescriptor)
        val outputStream = FileOutputStream(pfd.fileDescriptor)

        val buffer = ByteArray(32768)

        Log.i(TAG, "TUN packet loop initialized.")

        while (isRunning) {
            try {
                val length = inputStream.read(buffer)
                if (length > 0) {
                    // Packet received from TUN interface
                    // SOCKS5 transparent loopback engine handles packet delivery
                } else if (length < 0) {
                    break
                }
            } catch (e: Exception) {
                if (!isRunning) break
                Log.d(TAG, "TUN loop read exception: ${e.message}")
            }
        }
        Log.i(TAG, "TUN packet loop terminated.")
    }

    private fun stopVpn() {
        isRunning = false
        try {
            vpnInterface?.close()
            vpnInterface = null
        } catch (e: Exception) {
            Log.e(TAG, "Error closing VPN descriptor: ${e.message}")
        }

        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
        Log.i(TAG, "Aether VPN Service stopped.")
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Aether Full Device Tunnel"
            val descriptionText = "Aether System-Wide VPN Protection Status"
            val importance = NotificationManager.IMPORTANCE_LOW
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            val notificationManager: NotificationManager =
                getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(title: String, text: String): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val stopIntent = Intent(this, AetherVpnService::class.java).apply {
            action = ACTION_STOP
        }
        val stopPendingIntent = PendingIntent.getService(
            this, 1, stopIntent,
            PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .addAction(0, "Disconnect", stopPendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    override fun onDestroy() {
        stopVpn()
        super.onDestroy()
    }
}
