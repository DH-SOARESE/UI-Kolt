# 🎨 Kolt UI Library

> Uma biblioteca de interface moderna e responsiva para Roblox com suporte mobile e desktop

[![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)]()
[![Version](https://img.shields.io/badge/version-1.0-blue)]()
[![Platform](https://img.shields.io/badge/platform-Roblox-red)]()

---

## 📥 Instalação

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/UI-Kolt/refs/heads/main/Library.lua"))()()
```

---

## ✨ Características

- 🎯 **Interface Moderna**: Design minimalista com tema escuro
- 📱 **Responsivo**: Suporte completo para mobile e desktop
- 🔧 **Personalizável**: Sistema de abas e elementos configuráveis
- 🎨 **Componentes Ricos**: Toggles, Sliders, Dropdowns, Botões e mais
- 🔒 **Sistema de Bloqueio**: Lock/Unlock no mobile
- ⌨️ **Atalhos**: Toggle com F3 no desktop
- 🎭 **Animações Suaves**: Transições fluidas entre estados

---

## 🚀 Uso Básico

### Criar uma Janela

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/UI-Kolt/refs/heads/main/Library.lua"))()()

local Window = Library:CreateWindow({
    Title = "Minha UI",
    Center = true,  -- Centralizar janela
    MenuFadeTime = 0.2  -- Tempo de fade (segundos)
})
```

### Adicionar uma Aba

```lua
local Tab = Window:AddTab("Principal")
```

---

## 🧩 Componentes

### 🔘 Toggle (Interruptor)

```lua
Tab:AddToggle("auto_farm", {
    Text = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Toggle:", state)
    end
})
```

**Opções:**
- `Text` - Texto do toggle
- `Default` - Estado inicial (true/false)
- `Disabled` - Desabilitar interação
- `Callback` - Função chamada ao mudar estado

---

### 🎚️ Slider (Controle Deslizante)

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
- `Suffix` - Sufixo (ex: "%", "x", "m/s")
- `Rounding` - Incremento (1 = inteiros, 0.1 = decimais)
- `Compact` - Modo compacto (nome + valor na mesma linha)
- `HideMax` - Ocultar valor máximo
- `Callback` - Função chamada ao mudar valor

**Modos de Exibição:**

**Normal:**
```
Velocidade
[████████░░] 80 / 100%
```

**Compact:**
```
[██████████] Velocidade: 80%
```

---

### 📋 Dropdown (Menu Suspenso)

```lua
Tab:AddDropdown("mapa", {
    Text = "Selecione o Mapa",
    Value = {"Mapa 1", "Mapa 2", "Mapa 3"},
    Default = "Mapa 1",
    Mult = false,  -- Seleção múltipla
    Callback = function(selected)
        print("Selecionado:", selected)
    end
})
```

**Opções:**
- `Text` - Nome do dropdown
- `Value` - Lista de opções (array)
- `Default` - Valor(es) inicial(is)
- `Mult` - Permitir seleção múltipla
- `Callback` - Função chamada ao selecionar

**Seleção Múltipla:**
```lua
Tab:AddDropdown("itens", {
    Text = "Itens",
    Value = {"Espada", "Escudo", "Poção"},
    Default = {"Espada", "Escudo"},
    Mult = true,
    Callback = function(selected)
        -- selected é uma array: {"Espada", "Escudo"}
    end
})
```

---

### 🔵 Button (Botão)

```lua
Tab:AddButton("salvar", {
    Text = "Salvar Config",
    Callback = function()
        print("Salvando...")
    end
})
```

**Opções:**
- `Text` - Texto do botão
- `Size` - Tamanho customizado (UDim2)
- `Callback` - Função ao clicar

---

### 📝 Label (Texto)

```lua
Tab:AddLabel("info", {
    Text = "Bem-vindo à UI!",
    Size = UDim2.new(1, 0, 0, 22)  -- Opcional
})
```

**Opções:**
- `Text` - Conteúdo do texto
- `Size` - Tamanho (UDim2)

---

### ➖ Divider (Divisor)

```lua
Tab:AddDivider("div1", {
    Size = UDim2.new(1, 0, 0, 6)  -- Opcional
})
```

---

## 🎮 Controles

### 💻 Desktop
- **F3** - Mostrar/Ocultar UI

### 📱 Mobile
- **Botão "Toggle UI"** - Mostrar/Ocultar UI
- **Botão "Lock/Unlock"** - Bloquear/Desbloquear movimento da janela

---

## ⚙️ Configurações Avançadas

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
Library.Unload()  -- Remove todas as janelas
```

---

## 📱 Design Responsivo

A biblioteca detecta automaticamente o tamanho da tela:

- **Mobile**: `< 768px` de largura
  - UI ocupa 90% da tela
  - Botões de controle flutuantes
  - Elementos maiores para toque

- **Desktop**: `≥ 768px` de largura
  - Janela de tamanho fixo (536x296)
  - Controles por teclado
  - Interface compacta

---

## 🎨 Tema de Cores

```lua
Background = RGB(30, 30, 30)
InnerBackground = RGB(35, 35, 35)
Outline = RGB(50, 50, 50)
Accent = RGB(130, 55, 236) -- Roxo
Text = RGB(255, 255, 255)
DarkText = RGB(170, 170, 170)
```

---

## 📦 Exemplo Completo

```lua
-- Carregar biblioteca
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/UI-Kolt/refs/heads/main/Library.lua"))()()

-- Criar janela
local Window = Library:CreateWindow({
    Title = "Script Hub",
    Center = true
})

-- Criar aba
local MainTab = Window:AddTab("Principal")

-- Adicionar elementos
MainTab:AddLabel("lbl1", {
    Text = "=== Configurações ==="
})

MainTab:AddToggle("autofarm", {
    Text = "Auto Farm",
    Default = false,
    Callback = function(state)
        _G.AutoFarm = state
    end
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
    Value = {"Espada", "Pistola", "Rifle"},
    Default = "Espada",
    Callback = function(selected)
        print("Arma selecionada:", selected[1])
    end
})

MainTab:AddButton("reset", {
    Text = "Resetar Personagem",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end
})

-- Segunda aba
local SettingsTab = Window:AddTab("Configurações")

SettingsTab:AddToggle("esp", {
    Text = "ESP",
    Default = false,
    Callback = function(state)
        _G.ESP = state
    end
})
```

---

## 🐛 Solução de Problemas

### UI não aparece
- Verifique se o executor suporta `gethui()` ou `game:GetService("CoreGui")`
- Tente pressionar F3 (desktop) ou o botão Toggle UI (mobile)

### Slider não atualiza
- Certifique-se de que `Rounding` está correto
- Valores decimais requerem `Rounding = 0.1` ou menor

### Dropdown não fecha (mobile)
- Use `Mult = false` para fechar automaticamente ao selecionar
- Com `Mult = true`, clique no botão ▼ novamente

---

## 🔄 Status do Desenvolvimento

- [x] Sistema de janelas
- [x] Sistema de abas
- [x] Toggles
- [x] Sliders (normal e compacto)
- [x] Botões
- [x] Labels
- [x] Divisores
- [x] Dropdowns (simples e múltiplo)
- [x] Suporte mobile
- [x] Sistema de drag
- [x] Toggle UI (F3 / Botão)
- [ ] Colorpicker
- [ ] Textbox
- [ ] Keybind
- [ ] Sistema de salvamento

---

## 📄 Licença

Esta biblioteca está em desenvolvimento e é fornecida "como está".

---

## 💡 Dicas

1. **Performance**: Evite callbacks pesados em sliders/toggles
2. **Organização**: Use divisores para separar seções
3. **Mobile**: Teste sempre em dispositivos móveis
4. **IDs únicos**: Use IDs diferentes para cada elemento

---

## 🤝 Contribuindo

Este projeto está em desenvolvimento ativo. Sugestões e feedback são bem-vindos!

---

<div align="center">

**Feito com ❤️ para a comunidade Roblox**

[Reportar Bug](https://github.com/DH-SOARESE/UI-Kolt/issues) • [Sugerir Feature](https://github.com/DH-SOARESE/UI-Kolt/issues)

</div>
