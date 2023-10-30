import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp()); //// Iniciamos la aplicación llamando al widget MyApp
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SessionManager(),
    );
  }
}


// SessionManager maneja la lógica de inicio de sesión y enrutamiento
class SessionManager extends StatefulWidget {
  @override
  _SessionManagerState createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Verifica si el usuario está autenticado al iniciar la aplicación
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(username: "Omar")),
      );
    }
  }

  void login(String username, String password) async {
    if (username == "omar" && password == "123456") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); // Establece que el usuario está autenticado
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(username: "Omar")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Credenciales incorrectas'), // Muestra un mensaje de error en caso de credenciales incorrectas
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return LoginPage(loginCallback: login); // Muestra la pantalla de inicio de sesión y pasa una función de inicio de sesión
  }
}



// LoginPage muestra la interfaz de inicio de sesión
class LoginPage extends StatelessWidget {
  final void Function(String username, String password) loginCallback;

  LoginPage({required this.loginCallback});

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de sesión'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 450,
                height: 450,
                child: Image.asset("assets/gta.png"),
              ),
            ),
            Text(
              'Ingrese sus credenciales:',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuario',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                fillColor: Colors.white,
                filled: true,
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                loginCallback(_usernameController.text, _passwordController.text); // Llama a la función de inicio de sesión cuando se presiona el botón
              },
              child: Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}


// HomePage muestra la página principal después del inicio de sesión
class HomePage extends StatelessWidget {
  final String username;

  HomePage({required this.username});

  final TextEditingController nombreCompletoController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de inicio'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logout(context);  // Cierra la sesión del usuario cuando se presiona el botón
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('Bienvenido, ${username}'),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset("assets/rlogo.png"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text('Datos del Usuario:'),
            ),
            TextFormField(
              controller: nombreCompletoController,
              decoration: InputDecoration(labelText: 'Nombre Completo'),
            ),
            TextFormField(
              controller: nicknameController,
              decoration: InputDecoration(labelText: 'Nickname'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            TextFormField(
              controller: telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextFormField(
              controller: direccionController,
              decoration: InputDecoration(labelText: 'Dirección'),
            ),
            ElevatedButton(
              onPressed: () {
                saveUserData();

                print('Datos guardados');
              },
              child: Text('Guardar Datos'),
            ),
          ],
        ),
      ),
    );
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(loginCallback: (String username, String password) {}),
      ),
    );
  }

  void saveUserData() async {
    print('Guardando datos...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nombreCompleto', nombreCompletoController.text);
    prefs.setString('nickname', nicknameController.text);
    prefs.setString('email', emailController.text);
    prefs.setString('telefono', telefonoController.text);
    prefs.setString('direccion', direccionController.text);
    print('Datos guardados.');
  }
}



