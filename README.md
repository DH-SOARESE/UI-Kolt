# Kolt UI Library

Uma biblioteca de interface moderna e responsiva para Roblox com suporte completo para mobile e desktop.

[![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)]()
[![Version](https://img.shields.io/badge/version-1.0-blue)]()
[![Platform](https://img.shields.io/badge/platform-Roblox-red)]()

---

## Instalação

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/UI-Kolt/refs/heads/main/Library.lua"))()()
```

---

## Características

- Interface moderna com tema escuro personalizado
- Design totalmente responsivo (mobile e desktop)
- Sistema de abas com navegação intuitiva
- Componentes ricos: Toggle, Slider, Dropdown, Button, Label, Divider
- Sistema de cursor personalizado automático
- Animações suaves e transições fluidas
- Sistema de bloqueio de movimento (mobile)
- Atalho de teclado F3 para toggle (desktop)
- Suporte a DPI scaling
- Double-click confirmation nos botões

---

## Uso Básico

### Criar uma Janela

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/UI-Kolt/refs/heads/main/Library.lua"))()()

local Window = Library:CreateWindow({
    Title = "Minha UI",
    Center = true,
    MenuFadeTime = 0.15
})
```

**Opções:**
- `Title` - Título da janela
- `Center` - Centralizar janela (padrão: true)
- `MenuFadeTime` - Tempo de fade em segundos (padrão: 0.15)

### Adicionar uma Aba

```lua
local Tab = Window:AddTab("Principal")
```

---

## Componentes

### Toggle

Interruptor com suporte a KeyPicker integrado.

```lua
local Toggle = Tab:AddToggle("auto_farm", {
    Text = "Auto Farm",
    Default = false,
    Disabled = false,
    Callback = function(state)
        print("Toggle:", state)
    end
})

-- Adicionar KeyPicker ao Toggle
Toggle:AddKeyPicker("farm_key", {
    Mode = "Toggle",
    Default = "F",
    Text = "Hotkey",
    SyncToggleState = false
})
```

**Opções Toggle:**
- `Text` - Texto do toggle
- `Default` - Estado inicial (true/false)
- `Disabled` - Desabilitar interação
- `Callback` - Função ao mudar estado

**Opções KeyPicker:**
- `Mode` - Modo de ativação ("Toggle")
- `Default` - Tecla padrão (ex: "F", "G")
- `Text` - Texto exibido
- `SyncToggleState` - Sincronizar com estado do toggle

---

### Slider

Controle deslizante com dois modos de exibição.

```lua
Tab:AddSlider("velocidade", {
    Text = "Velocidade",
    Default = 50,
    Min = 0,
    Max = 100,
    Suffix = "%",
    Rounding = 1,
    Compact = false,
    HideMax = false,
    Callback = function(value)
        print("Valor:", value)
    end
})
```

**Opções:**
- `Text` - Nome do slider
- `Default` - Valor inicial
- `Min` - Valor mínimo
- `Max` - Valor máximo
- `Suffix` - Sufixo exibido (%, x, m/s)
- `Rounding` - Incremento (1 = inteiros, 0.1 = decimais)
- `Compact` - Modo compacto (nome + valor mesma linha)
- `HideMax` - Ocultar valor máximo
- `Callback` - Função ao mudar valor

**Exemplo Modo Normal:**
```
Velocidade
[████████░░] 80 / 100%
```

**Exemplo Modo Compact:**
```
[██████████] Velocidade: 80%
```

---

### Dropdown

Menu suspenso com seleção simples ou múltipla.

```lua
Tab:AddDropdown("mapa", {
    Text = "Selecione o Mapa",
    Value = {"Mapa 1", "Mapa 2", "Mapa 3"},
    Default = "Mapa 1",
    Mult = false,
    Callback = function(selected)
        print("Selecionado:", selected)
    end
})
```

**Opções:**
- `Text` - Nome do dropdown
- `Value` - Array de opções
- `Default` - Valor(es) inicial(is)
- `Mult` - Permitir seleção múltipla
- `Callback` - Função ao selecionar

**Seleção Múltipla:**
```lua
Tab:AddDropdown("itens", {
    Text = "Itens",
    Value = {"Espada", "Escudo", "Poção"},
    Default = {"Espada", "Escudo"},
    Mult = true,
    Callback = function(selected)
        -- selected é array: {"Espada", "Escudo"}
    end
})
```

**Recursos:**
- Scroll automático para listas grandes
- Destaque visual para itens selecionados
- Auto-close em seleção simples
- Máximo de 150px de altura com scroll

---

### Button

Botão com suporte a confirmação de double-click.

```lua
Tab:AddButton("reset", {
    Text = "Resetar",
    DoubleClick = false,
    ConfirmText = "Tem certeza?",
    Callback = function()
        print("Executado!")
    end
})
```

**Opções:**
- `Text` - Texto do botão
- `Size` - Tamanho customizado (UDim2)
- `DoubleClick` - Requer duplo clique (padrão: false)
- `ConfirmText` - Texto de confirmação
- `Callback` - Função ao clicar

**Double-Click:**
- Primeiro clique: Exibe texto de confirmação
- Segundo clique (em 0.3s): Executa ação
- Timeout: 1 segundo para retornar ao normal
- Animação suave na transição de texto

---

### Label

Texto estático para informações.

```lua
Tab:AddLabel("info", {
    Text = "Bem-vindo à UI!",
    Size = UDim2.new(1, 0, 0, 22)
})
```

**Opções:**
- `Text` - Conteúdo do texto
- `Size` - Tamanho (UDim2, opcional)

---

### Divider

Divisor visual para organizar seções.

```lua
Tab:AddDivider("div1", {
    Size = UDim2.new(1, 0, 0, 6)
})
```

**Opções:**
- `Size` - Tamanho (UDim2, opcional)

---

## Controles

### Desktop
- **F3** - Mostrar/Ocultar UI
- **Cursor Personalizado** - Ativado automaticamente ao abrir UI

### Mobile
- **Botão "Toggle UI"** - Mostrar/Ocultar UI
- **Botão "Lock/Unlock"** - Bloquear/Desbloquear movimento da janela
- **Touch Controls** - Todos os elementos otimizados para toque

---

## Configurações Avançadas

### Escala DPI

```lua
Library.DPIScale(150)  -- 150% de zoom
```

### Detecção de Mobile Manual

```lua
Library.IsMobile = true  -- Forçar modo mobile
```

### Descarregar UI

```lua
Library.Unload()  -- Remove todas as janelas e restaura cursor
```

---

## Design Responsivo

A biblioteca detecta automaticamente o dispositivo:

**Mobile (< 768px):**
- UI ocupa 90% da largura e 85% da altura
- Botões flutuantes de controle
- Elementos maiores para toque
- Scroll otimizado

**Desktop (≥ 768px):**
- Janela fixa de 536x296 pixels
- Controles por teclado (F3)
- Interface compacta
- Cursor personalizado

---

## Tema de Cores

```lua
Background       = RGB(28, 28, 28)
InnerBackground  = RGB(32, 32, 32)
Outline          = RGB(45, 45, 45)
Accent           = RGB(140, 60, 245)  -- Roxo vibrante
Text             = RGB(245, 245, 245)
DarkText         = RGB(160, 160, 160)
```

**Border Radius:**
- MainFrame: 8px
- Componentes: 6px
- Detalhes: 4px

---

## Exemplo Completo

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/UI-Kolt/refs/heads/main/Library.lua"))()()

local Window = Library:CreateWindow({
    Title = "Script Hub v1.0",
    Center = true
})

-- Aba Principal
local MainTab = Window:AddTab("Principal")

MainTab:AddLabel("lbl1", {
    Text = "=== Auto Farm ==="
})

local farmToggle = MainTab:AddToggle("autofarm", {
    Text = "Auto Farm",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
    end
})

farmToggle:AddKeyPicker("farm_key", {
    Mode = "Toggle",
    Default = "F",
    Text = "Hotkey"
})

MainTab:AddSlider("speed", {
    Text = "Velocidade",
    Default = 16,
    Min = 16,
    Max = 100,
    Suffix = " m/s",
    Rounding = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

MainTab:AddDivider("div1", {})

MainTab:AddDropdown("weapon", {
    Text = "Arma",
    Value = {"Espada", "Pistola", "Rifle", "Arco"},
    Default = "Espada",
    Callback = function(selected)
        _G.SelectedWeapon = selected[1]
    end
})

MainTab:AddButton("reset", {
    Text = "Resetar Personagem",
    DoubleClick = true,
    ConfirmText = "Confirmar Reset?",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end
})

-- Aba Configurações
local SettingsTab = Window:AddTab("Configurações")

SettingsTab:AddLabel("lbl2", {
    Text = "=== Visual ==="
})

SettingsTab:AddToggle("esp", {
    Text = "ESP Players",
    Default = false,
    Callback = function(state)
        _G.ESP = state
    end
})

SettingsTab:AddSlider("fov", {
    Text = "FOV",
    Default = 70,
    Min = 60,
    Max = 120,
    Compact = true,
    Rounding = 5,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})
```

---

## Solução de Problemas

### UI não aparece
- Verifique se o executor suporta `gethui()` ou `CoreGui`
- Pressione F3 (desktop) ou botão Toggle UI (mobile)
- Verifique console por erros

### Slider não responde
- Certifique-se de que `Rounding` está correto
- Valores decimais precisam de `Rounding = 0.1` ou menor
- Verifique se Min < Max

### Dropdown não fecha
- Use `Mult = false` para auto-close
- Com `Mult = true`, clique no botão ▼ novamente

### Cursor personalizado não aparece
- Cursor é ativado automaticamente ao abrir UI
- Desativado ao fechar UI (F3 ou Toggle)

### Double-click não funciona
- Defina `DoubleClick = true`
- Clique duas vezes em menos de 0.3 segundos
- Aguarde timeout de 1 segundo se errar

---

## Status do Desenvolvimento

**Implementado:**
- [x] Sistema de janelas
- [x] Sistema de abas com scroll
- [x] Toggle com KeyPicker
- [x] Slider (normal e compacto)
- [x] Dropdown (simples e múltiplo)
- [x] Button com double-click
- [x] Label e Divider
- [x] Cursor personalizado
- [x] Suporte mobile completo
- [x] Sistema de drag/lock
- [x] Toggle UI (F3/Botão)
- [x] DPI Scaling

**Planejado:**
- [ ] ColorPicker
- [ ] TextBox
- [ ] Keybind Customizável
- [ ] Sistema de salvamento de configurações
- [ ] Temas customizáveis
- [ ] Notificações
- [ ] Searchbox para dropdowns longos

---

## Notas Técnicas

### Performance
- Evite callbacks pesados em sliders/toggles
- Use `Compact = true` em sliders quando possível
- Limite dropdowns a ~50 opções

### Organização
- Use IDs únicos para cada elemento
- Organize elementos com dividers
- Agrupe funcionalidades relacionadas em abas

### Mobile
- Teste sempre em dispositivos móveis
- Botões de controle são posicionados automaticamente
- Touch gestures otimizados

### Cursor
- Cursor personalizado usa ID: `rbxassetid://12230889708`
- Atualizado a cada frame via `RunService.RenderStepped`
- Restaura cursor padrão ao fechar UI

---

## API Reference

### Library

```lua
Library.DPIScale(scale: number)
Library.Unload()
Library.IsMobile = boolean
Library:CreateWindow(config: table) -> Window
```

### Window

```lua
Window:AddTab(name: string) -> Tab
Window:SelectTab(tab: Tab)
Window:CreateCustomCursor()
Window:DestroyCustomCursor()
```

### Tab

```lua
Tab:AddToggle(id: string, config: table) -> Toggle
Tab:AddSlider(id: string, config: table) -> Slider
Tab:AddDropdown(id: string, config: table) -> Dropdown
Tab:AddButton(id: string, config: table) -> Button
Tab:AddLabel(id: string, config: table) -> Label
Tab:AddDivider(id: string, config: table) -> Divider
```

### Toggle

```lua
Toggle:AddKeyPicker(id: string, config: table) -> KeyPicker
```

---

## Licença

Esta biblioteca está em desenvolvimento ativo e é fornecida "como está" sem garantias.

---

## Contribuindo

Sugestões, bugs e feedback são bem-vindos!

[Reportar Bug](https://github.com/DH-SOARESE/UI-Kolt/issues) • [Sugerir Feature](https://github.com/DH-SOARESE/UI-Kolt/issues)

---

**Desenvolvido para a comunidade Roblox**
