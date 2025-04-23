import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneOrEmailController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Senha'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ícone e título
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.lock_reset,
                          size: 80,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Recuperação de Senha',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Informe seu e-mail ou telefone para receber instruções de recuperação',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Opções de recuperação
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEmailSelected = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isEmailSelected 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey.shade200,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              'E-mail',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _isEmailSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isEmailSelected = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isEmailSelected 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey.shade200,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Telefone',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !_isEmailSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Campo de e-mail ou telefone
                  TextFormField(
                    controller: _phoneOrEmailController,
                    keyboardType: _isEmailSelected 
                      ? TextInputType.emailAddress 
                      : TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: _isEmailSelected ? 'E-mail' : 'Telefone',
                      prefixIcon: Icon(_isEmailSelected ? Icons.email : Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _isEmailSelected 
                          ? 'Por favor, insira seu e-mail' 
                          : 'Por favor, insira seu telefone';
                      }
                      
                      if (_isEmailSelected) {
                        // Validação básica de e-mail
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Por favor, insira um e-mail válido';
                        }
                      }
                      
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Botão de enviar
                  ElevatedButton(
                    onPressed: _isLoading ? null : _recoverPassword,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Enviar Instruções',
                          style: TextStyle(fontSize: 16),
                        ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Link para voltar ao login
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Voltar para o login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Future<void> _recoverPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final success = await authService.recoverPassword(_phoneOrEmailController.text);
        
        if (success) {
          // Mostrar mensagem de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Instruções de recuperação enviadas para ${_phoneOrEmailController.text}',
              ),
              backgroundColor: Colors.green,
            ),
          );
          
          // Voltar para tela de login após alguns segundos
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pop(context);
          });
        } else {
          // Mostrar mensagem de erro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Não foi possível enviar as instruções. Verifique os dados e tente novamente.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Mostrar mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao recuperar senha: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
