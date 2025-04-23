import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        children: [
          // Seção de tema
          ListTile(
            title: Text(
              'Tema',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          
          // Opções de tema
          _buildThemeOption(
            context, 
            'Tático (Verde-oliva)', 
            'tactical',
            themeProvider,
            Icon(Icons.shield, color: Color(0xFF556B2F)),
          ),
          _buildThemeOption(
            context, 
            'Claro', 
            'light',
            themeProvider,
            Icon(Icons.light_mode, color: Colors.amber),
          ),
          _buildThemeOption(
            context, 
            'Escuro', 
            'dark',
            themeProvider,
            Icon(Icons.dark_mode, color: Colors.blueGrey[800]),
          ),
          _buildThemeOption(
            context, 
            'Azul', 
            'blue',
            themeProvider,
            Icon(Icons.water, color: Colors.blue),
          ),
          _buildThemeOption(
            context, 
            'Rosa', 
            'pink',
            themeProvider,
            Icon(Icons.favorite, color: Colors.pink),
          ),
          
          Divider(),
          
          // Seção de notificações
          ListTile(
            title: Text(
              'Notificações',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SwitchListTile(
            title: Text('Lembrete de plantão'),
            subtitle: Text('Receber notificação 24h antes do plantão'),
            value: true, // Valor padrão
            onChanged: (value) {
              // Implementar lógica de notificações
            },
          ),
          
          Divider(),
          
          // Seção de conta
          ListTile(
            title: Text(
              'Conta',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Editar perfil'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navegar para tela de edição de perfil
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Alterar senha'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navegar para tela de alteração de senha
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
            onTap: () {
              // Implementar logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          
          Divider(),
          
          // Seção sobre
          ListTile(
            title: Text(
              'Sobre',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Versão do aplicativo'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ajuda e suporte'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navegar para tela de ajuda
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildThemeOption(
    BuildContext context, 
    String title, 
    String themeKey,
    ThemeProvider themeProvider,
    Icon icon,
  ) {
    final isSelected = themeProvider.currentThemeName == themeKey;
    
    return ListTile(
      leading: icon,
      title: Text(title),
      trailing: isSelected 
        ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor) 
        : null,
      onTap: () {
        themeProvider.setTheme(themeKey);
      },
    );
  }
}
