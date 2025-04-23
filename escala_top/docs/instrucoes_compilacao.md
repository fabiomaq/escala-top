# Instruções para Compilação do Aplicativo Escala Top

Este documento contém instruções detalhadas para compilar o aplicativo Escala Top para Android e iOS.

## Requisitos

Para compilar o aplicativo, você precisará ter instalado:

1. **Flutter SDK** (versão 3.19.0 ou superior)
2. **Android Studio** (para compilação Android)
3. **Xcode** (para compilação iOS, apenas em macOS)
4. **Android SDK** configurado
5. **Git**

## Configuração do Ambiente

### Instalação do Flutter

1. Baixe o Flutter SDK em [flutter.dev](https://flutter.dev/docs/get-started/install)
2. Extraia o arquivo baixado em um local de sua preferência
3. Adicione o diretório `flutter/bin` ao seu PATH
4. Execute `flutter doctor` para verificar se há dependências adicionais a serem instaladas

### Configuração do Android Studio

1. Baixe e instale o Android Studio em [developer.android.com](https://developer.android.com/studio)
2. Abra o Android Studio e siga o assistente de configuração
3. Instale o Android SDK (se não estiver instalado)
4. Instale o plugin Flutter no Android Studio

### Configuração do Xcode (apenas para macOS)

1. Baixe e instale o Xcode da App Store
2. Instale as ferramentas de linha de comando do Xcode executando `xcode-select --install`
3. Configure um simulador iOS

## Compilação do Aplicativo

### Para Android

1. Navegue até o diretório do projeto: `cd escala_top`
2. Execute `flutter build apk --release` para criar um APK de release
3. O APK será gerado em `build/app/outputs/flutter-apk/app-release.apk`

Alternativamente, para criar um bundle Android (recomendado para publicação na Play Store):
```
flutter build appbundle --release
```
O bundle será gerado em `build/app/outputs/bundle/release/app-release.aab`

### Para iOS (apenas em macOS)

1. Navegue até o diretório do projeto: `cd escala_top`
2. Execute `flutter build ios --release --no-codesign` para criar um build de release
3. Para distribuição na App Store, você precisará configurar o código de assinatura e usar o Xcode para arquivar e enviar o aplicativo

## Publicação nas Lojas

### Google Play Store

1. Crie uma conta de desenvolvedor na Google Play Console (taxa única de $25)
2. Crie um novo aplicativo na Play Console
3. Preencha todas as informações necessárias (descrição, capturas de tela, ícones, etc.)
4. Faça upload do arquivo AAB gerado
5. Configure preços e disponibilidade
6. Envie para revisão

### Apple App Store

1. Crie uma conta no Apple Developer Program (taxa anual de $99)
2. Crie um novo aplicativo no App Store Connect
3. Configure os certificados e perfis de provisionamento
4. Use o Xcode para arquivar e enviar o aplicativo para a App Store
5. Preencha todas as informações necessárias (descrição, capturas de tela, ícones, etc.)
6. Envie para revisão

## Solução de Problemas

Se encontrar problemas durante a compilação:

1. Execute `flutter clean` para limpar a build anterior
2. Verifique se todas as dependências estão atualizadas com `flutter pub get`
3. Execute `flutter doctor -v` para verificar se há problemas com o ambiente
4. Consulte a documentação oficial do Flutter em [flutter.dev/docs](https://flutter.dev/docs)

## Personalização

O aplicativo Escala Top foi desenvolvido com os seguintes recursos:

- Tipos de escala: 12x36, 12x24/12x48, 6x1, 5x2 e personalizada
- Temas: claro, escuro, tático (verde-oliva), azul e rosa
- Visualização mensal e anual do calendário
- Diferenciação entre escalas diurnas e noturnas
- Sistema de login com múltiplas opções
- Armazenamento local de histórico (limitado a 1 ano)

Para personalizar o aplicativo, você pode modificar os arquivos de código-fonte conforme necessário.
