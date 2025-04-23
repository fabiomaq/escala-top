import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  
  // Login com telefone e senha
  Future<bool> loginWithPhone(String phone, String password) async {
    try {
      // Simulação de autenticação - em um app real, isso seria uma chamada a uma API ou verificação em banco de dados
      await Future.delayed(Duration(seconds: 1));
      
      // Verificar credenciais (simulação)
      if (phone == '123456789' && password == '123456') {
        _currentUser = User(
          id: '1',
          name: 'Usuário Teste',
          phone: phone,
          email: 'usuario@teste.com',
        );
        _isAuthenticated = true;
        
        // Salvar estado de login
        await _saveAuthState(true, _currentUser!.id);
        
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Erro no login: $e');
      return false;
    }
  }
  
  // Login com e-mail
  Future<bool> loginWithEmail(String email, String password) async {
    try {
      // Simulação de autenticação
      await Future.delayed(Duration(seconds: 1));
      
      // Verificar credenciais (simulação)
      if (email == 'usuario@teste.com' && password == '123456') {
        _currentUser = User(
          id: '1',
          name: 'Usuário Teste',
          phone: '123456789',
          email: email,
        );
        _isAuthenticated = true;
        
        // Salvar estado de login
        await _saveAuthState(true, _currentUser!.id);
        
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Erro no login: $e');
      return false;
    }
  }
  
  // Login com redes sociais (simulação)
  Future<bool> loginWithSocial(String provider) async {
    try {
      // Simulação de autenticação com rede social
      await Future.delayed(Duration(seconds: 1));
      
      _currentUser = User(
        id: '1',
        name: 'Usuário $provider',
        phone: '123456789',
        email: 'usuario@$provider.com',
      );
      _isAuthenticated = true;
      
      // Salvar estado de login
      await _saveAuthState(true, _currentUser!.id);
      
      notifyListeners();
      return true;
    } catch (e) {
      print('Erro no login social: $e');
      return false;
    }
  }
  
  // Registro de novo usuário
  Future<bool> register(String name, String phone, String? email, String password) async {
    try {
      // Simulação de registro
      await Future.delayed(Duration(seconds: 1));
      
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        phone: phone,
        email: email,
      );
      _isAuthenticated = true;
      
      // Salvar estado de login
      await _saveAuthState(true, _currentUser!.id);
      
      notifyListeners();
      return true;
    } catch (e) {
      print('Erro no registro: $e');
      return false;
    }
  }
  
  // Recuperação de senha
  Future<bool> recoverPassword(String phoneOrEmail) async {
    try {
      // Simulação de recuperação de senha
      await Future.delayed(Duration(seconds: 1));
      
      // Em um app real, enviaria um código de verificação por SMS ou e-mail
      return true;
    } catch (e) {
      print('Erro na recuperação de senha: $e');
      return false;
    }
  }
  
  // Verificar se o usuário está logado ao iniciar o app
  Future<bool> checkAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAuth = prefs.getBool('isAuthenticated') ?? false;
      final userId = prefs.getString('userId');
      
      if (isAuth && userId != null) {
        // Em um app real, buscaria os dados do usuário no banco de dados ou API
        _currentUser = User(
          id: userId,
          name: 'Usuário Recuperado',
          phone: '123456789',
          email: 'usuario@teste.com',
        );
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Erro ao verificar estado de autenticação: $e');
      return false;
    }
  }
  
  // Logout
  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    
    // Limpar estado de login
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    await prefs.remove('userId');
    
    notifyListeners();
  }
  
  // Salvar estado de autenticação
  Future<void> _saveAuthState(bool isAuthenticated, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', isAuthenticated);
    await prefs.setString('userId', userId);
  }
}
