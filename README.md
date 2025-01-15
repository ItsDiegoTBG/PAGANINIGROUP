# Anexo de Instalacion

## _Guía de Instalación de Paganini_ 📱

## Requisitos Previos ✅
Antes de comenzar, asegúrate de tener lo siguiente instalado en tu máquina:

- **Flutter SDK** ([Guía oficial de instalación](https://flutter.dev/docs/get-started/install))
- **Dart SDK** (normalmente incluido con Flutter)
- **Git** (para clonar el repositorio)
- **Editor de Código** (recomendado: [Visual Studio Code](https://code.visualstudio.com/) o [Android Studio](https://developer.android.com/studio))
- **Emulador o Dispositivo Físico** (para pruebas)
- **Java Development Kit (JDK)** (para Android)

## Clonar el Repositorio
1. Abre una terminal.
2. Clona el repositorio con el siguiente comando:

   ```bash
   git clone https://github.com/ItsDiegoTBG/PAGANINIGROUP.git
   ```

## Accede al directorio del proyecto
   ```bash
   cd PAGANINIGROUP
   ```
## Configuracion del Entorno ⚙️

Verificacmos que el entorno de [Flutter](https://flutter.dev/) esta correctamente configurado con
```bash
flutter doctor
```
## Instalamos las depencias del Proyecto 
```bash
flutter pub get
```
## Ejecución de la aplicación 🚀
Para ejecutar la aplicacion en modo debug
```bash
flutter run
```
## Contrucción para prouducción

 _Para Android_: Ejecuta el siguiente coando para generar un APK
 ```bash
 flutter build apk --release
 ```
>Nota: El archivo estara en el directorio `build/app/outputs/flutter-apk`

_Para ios_:Asegúrate de tener una máquina macOS y Xcode instalado. Luego, ejecuta:
 ```bash
 flutter build ios --release
``` 
>Nota: El proyecto compilado se encuentra en la carpeta `build/ios/iphoneos` 

 ## Problemas Comunes
 - Dependencias no instaladas corractamente podemos verificar que todas las dependencias esten resueltas con 
 ```sh 
 flutter pub get
 ```

 - Error con dispositivos:Asegurate de que un emulador este corriendo o un dispositivo fidico este conectado
 - Asegura que si utilizas un dispositivo fisico para debugear la aplicacion permiso para el `USB debugging` que se habilidata en el _modo desarrollador_.
 
 ## Recomendaciones
 - Verificar la correcta instalacion de flutter en el sistema
 - El sdk de Java tiene que ser compatatible con la version de flutter
 - Si usa el editor de Vscode recomendamos los siguiente publings
 
## Plugins
| Plugin | README |
| ------ | ------ |
| Flutter Dart Code | https://dartcode.org/
| DartCode |  https://dartcode.org/


# Paganini

**Paganini** es un sistema de pagos que integra **Payment Gateway**, permitiendo realizar transacciones tanto presenciales como en línea sin necesidad de utilizar tarjetas o efectivo. Las transacciones se realizan mediante códigos QR o transferencias directas a otras cuentas. El proyecto tiene como resultado esperado el desarrollo de una **aplicación web** y una **aplicación móvil**.

## Actores del Sistema

- **Usuario Cliente**
- **Usuario Comercio** 
- **Administrador del Sistema** 

![Diagrama del Sistema](/assets/image/paganini_icono.png)

## Integrantes del Equipo

- **Diego Contreras**
- **Rafael Merchán**
- **Stiven Rivera**
- **Cristhian Santacruz**

## Horarios de Trabajo

| Integrante           | Días de trabajo              | Horario               |
|----------------------|------------------------------|-----------------------|
| Diego Contreras      | Lunes, Miércoles, Viernes    | 17:00 - 19:00         |
| Rafael Merchán       | Lunes, Miércoles, Viernes    | 19:00 - 21:00         |
| Stiven Rivera        | Lunes, Miércoles             | 8:00 - 11:00 am       |
| Cristhian Santacruz  | Viernes, Sábado              | 7:00 - 10:00 am       |

## Reunión con el Cliente

- **Horario Tentativo:** Viernes a las 6:00pm

## Enlaces Importantes

- [Repositorio del Proyecto](https://github.com/ItsDiegoTBG/PAGANINIGROUP)
- [Diseño en Figma](https://www.figma.com/design/HPmkTYI7NAjY4HPvg3uvL7/Paganini-Mobile?node-id=0-1&node-type=canvas&t=GlMAV0dP4uLtuYOk-0)
- [Notion](https://www.notion.so/PAGANINI-MOBILE-SCRUM-e4c4c8c83c2144a7886ab36b70e31421)

## Backlog del Proyecto

- Permitir al usuario ingresar a su cuenta por medio de un correo y clave. ✖️
- Permitir a los usuarios registrar múltiples tarjetas de crédito o débito creando una billetera virtual. ✖️
- Permitir pagos móviles utilizando tarjetas tanto en la página web como en la aplicación.
- Permitir a los usuarios añadir y eliminar tarjetas de crédito o débito. ✖️
- Recargar saldo a través de la página web o la aplicación móvil.
- Visualizar el saldo disponible en la cuenta. ✖️
- Realizar transferencias de saldo entre usuarios.
- Seleccionar y guardar el método de pago favorito. 
- Crear cuentas usando tarjetas de bancos pequeños para probar la aplicación. 
- Diseñar y desarrollar una base de datos relacional que incluya la entidad de tarjetas de los usuarios.
- Implementar soporte para el uso de criptomonedas.
- Realizar pagos mediante escaneo de códigos QR, con descuentos en bancos asociados.
- Transferir el saldo de la aplicación de vuelta a la cuenta bancaria del usuario.
- Dividir una transacción entre diferentes métodos de pago utilizando varias tarjetas.
- Historial detallado de transacciones, recargas, pagos y transferencias.
- Diseño atractivo y experiencia de usuario intuitiva. ✖️
- Integración con métodos de pago como Apple Pay y Google Pay.

---

¡Gracias por ser parte de **Paganini**!
