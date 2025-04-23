import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(Duration(seconds: 2)); // Exibir splash por 2 segundos
    
    if (!mounted) return;
    
    final authService = Provider.of<AuthService>(context, listen: false);
    final isAuthenticated = await authService.checkAuthState();
    
    if (!mounted) return;
    
    if (isAuthenticated) {
      // Usuário já está autenticado, navegar para a tela principal
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Usuário não está autenticado, navegar para a tela de login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo do aplicativo
            Icon(
              Icons.calendar_month,
              size: 120,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            Text(
              'Escala Top',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Gerencie suas escalas de serviço',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
