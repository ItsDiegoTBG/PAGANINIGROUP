import 'package:flutter/material.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lista de notificaciones de ejemplo
    final notifications = [
      {
        'title': 'Pago recibido',
        'time': '10:30 AM',
        'message': 'Has recibido un pago de \$150.00 por la tarjeta XXXXXXXXXXXX',
        'isRead': false,
        'icon': Icons.payment,
        'iconColor': Colors.green,
      },
      {
        'title': 'Recordatorio',
        'message': 'Tienes una factura pendiente por pagar',
        'time': 'Ayer',
        'isRead': true,
        'icon': Icons.receipt_long,
        'iconColor': Colors.orange,
      },
      {
        'title': 'Promoción',
        'message': '25% de descuento en tu próxima transacción',
        'time': '24 Abr',
        'isRead': true,
        'icon': Icons.discount,
        'iconColor': Colors.purple,
      },
      {
        'title': 'Actualización',
        'message': 'Hemos actualizado nuestros términos de servicio',
        'time': '20 Abr',
        'isRead': true,
        'icon': Icons.info_outline,
        'iconColor': Colors.blue,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Mostrar opciones
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.check_circle_outline),
                        title: const Text('Marcar todas como leídas'),
                        onTap: () {
                          Navigator.pop(context);
                          // Lógica para marcar todas como leídas
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline),
                        title: const Text('Eliminar todas las notificaciones'),
                        onTap: () {
                          Navigator.pop(context);
                          // Lógica para eliminar todas
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No tienes notificaciones',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  title: notification['title'] as String,
                  message: notification['message'] as String,
                  time: notification['time'] as String,
                  isRead: notification['isRead'] as bool,
                  icon: notification['icon'] as IconData,
                  iconColor: notification['iconColor'] as Color,
                  onTap: () {
                    // Lógica al presionar una notificación
                  },
                );
              },
            ),
    );
  }
}

// Componente para cada tarjeta de notificación
class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final IconData icon;
  final Color iconColor;
  final Function() onTap;

  const NotificationCard({
    Key? key,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        color: isRead ? Colors.white : Colors.blue.shade50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ejemplo de cómo usar el AppBar personalizado en cualquier pantalla:
/*
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(
      primerNombre: 'María',
      notificationCount: 3,
      onNotificationPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationScreen()),
        );
      },
    ),
    body: // Tu contenido aquí
  );
}
*/