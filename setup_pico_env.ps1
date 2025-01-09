# Configuração do ambiente de desenvolvimento Raspberry Pi Pico no Windows

# Atualize o sistema
Write-Host "Atualizando o sistema..." -ForegroundColor Green
winget upgrade --all

# Instalar dependências
Write-Host "Instalando dependências: Git, CMake, Ninja, Python, GNU Arm Toolchain..." -ForegroundColor Green
winget install --id Git.Git -e
winget install --id Kitware.CMake -e
winget install --id Ninja-build.Ninja -e
winget install --id Python.Python.3 -e
winget install --id ARM.GNU-Arm-Embedded-Toolchain -e

# Criar diretório para o SDK
Write-Host "Configurando diretórios para o SDK do Pico..." -ForegroundColor Green
$baseDir = "$HOME\Pico"
$repoDir = "$baseDir\repos"
$examplesDir = "$baseDir\pico-examples"
New-Item -ItemType Directory -Path $baseDir -Force
New-Item -ItemType Directory -Path $repoDir -Force

# Clonar repositórios do SDK
Write-Host "Clonando o Raspberry Pi Pico SDK e exemplos..." -ForegroundColor Green
git clone -b master https://github.com/raspberrypi/pico-sdk.git "$repoDir\pico-sdk"
git clone -b master https://github.com/raspberrypi/pico-examples.git "$examplesDir"

# Configurar SDK no PATH e variáveis de ambiente
Write-Host "Configurando variáveis de ambiente..." -ForegroundColor Green
[System.Environment]::SetEnvironmentVariable("PICO_SDK_PATH", "$repoDir\pico-sdk", [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("PICO_EXAMPLES_PATH", "$examplesDir", [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("Path", "$($env:Path);$baseDir\tools", [System.EnvironmentVariableTarget]::User)

# Inicializar submódulos do SDK
Write-Host "Inicializando submódulos do Pico SDK..." -ForegroundColor Green
cd "$repoDir\pico-sdk"
git submodule update --init

# Configurar VS Code
Write-Host "Instalando VS Code e extensões recomendadas..." -ForegroundColor Green
winget install --id Microsoft.VisualStudioCode -e
code --install-extension ms-vscode.cmake-tools
code --install-extension ms-python.python
code --install-extension ms-vscode.cpptools

# Configuração concluída
Write-Host "Configuração concluída! Reinicie o terminal para aplicar as mudanças." -ForegroundColor Green
