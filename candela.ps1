$inject = "function CandelaTranscription (){ 
`$ww = '0123456789'
`$string = ''
for (`$i = 0; `$i -lt `$lunghezza; `$i++) {
    `$index = Get-Random -Minimum 0 -Maximum `$ww.Length
    `$string += `$ww[`$index]
}

Start-Transcript -Path '`$env:USERPROFILE\Documents\Candela_collection\transcript_`$string.txt' -IncludeInvocationHeader
}"

$import_c = "`n. '$env:USERPROFILE\Documents\WindowsPowershell\candela_transcription.ps1'; CandelaTranscription"
$candela_path = "$env:USERPROFILE\Documents\WindowsPowershell\candela_transcription.ps1"


#TODO: check on every file
function Init(){
    #check folder
    if(-not (Test-Path $profile)){
        New-Item -Path "$env:USERPROFILE\Documents\WindowsPowershell" -ItemType Directory
        New-Item -Path "$env:USERPROFILE\Documents\WindowsPowershell\Microsoft.Powershell_profile.ps1" -ItemType "file"
        New-Item -Path "$env:USERPROFILE\Documents\WindowsPowershell\Microsoft.PowershellSE_profile.ps1" -ItemType "file"
        New-Item -Path "$env:USERPROFILE\Documents\WindowsPowershell\Microsoft.VSCode_profile.ps1" -ItemType "file"
        New-Item -Path $candela_path -ItemType "file" -Value $inject
    }

    #create log folder
    if(-not (Test-Path "$env:USERPROFILE\Documents\Candela_collection")){
        New-Item -Path "$env:USERPROFILE\Documents\Candela_collection" -ItemType Directory
    }

    #check transcription
    if(-not (Test-Path $candela_path)){
        New-Item -Path $candela_path -ItemType "file" -Value $inject
    }
}

#enable tracking (TODO: upgrade anche per tutti gli altri)
function EnableTracking (){

    $import_c| Out-File -FilePath $profile -Append
}

#disable tracking
function DisableTracking(){
    Get-Content -Path $profile | Where-Object { $_ -ne $import_c } | Set-Content -Path $profile
}

function DetectionTracking(){
    return Where-Object { $_.ToLower() -ne $import_c }
}


Init

# Carica l'assembly di Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Crea una nuova finestra (form)
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Candela - The Red Tracker'
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.MaximizeBox = $false  # Disabilita il pulsante per massimizzare
$form.MinimizeBox = $true  # Abilita il pulsante per minimizzare
#$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog # Impedisce il ridimensionamento della finestra

# Crea il TabControl
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(380, 200)
$tabControl.Location = New-Object System.Drawing.Point(10, 10)  # Posiziona il TabControl direttamente in alto

# Crea i TabPage (le diverse pagine)
$tabPageA = New-Object System.Windows.Forms.TabPage
$tabPageA.Text = 'Log'

$tabPageB = New-Object System.Windows.Forms.TabPage
$tabPageB.Text = 'Capture'

$tabPageC = New-Object System.Windows.Forms.TabPage
$tabPageC.Text = 'About'

# Aggiungi il contenuto a ciascun TabPage
# Contenuto della Pagina A
$labelA = New-Object System.Windows.Forms.Label
$labelA.Text = 'Log collection'
$labelA.Location = New-Object System.Drawing.Point(30, 50)
$tabPageA.Controls.Add($labelA)

# Pulsante accanto alla scritta (Button)
$buttonA = New-Object System.Windows.Forms.Button


$buttonA.Size = New-Object System.Drawing.Size(100, 30)
$buttonA.Location = New-Object System.Drawing.Point(200, 50)  # Posiziona il pulsante accanto alla scritta
$buttonA.Text = "Enable"
$pressCount = 0

$buttonA.Add_Click({
    $global:pressCount++
    if ($global:pressCount % 2 -eq 1){     
        EnableTracking
        [System.Windows.Forms.MessageBox]::Show('Log collection enabled')
        $buttonA.Text = 'Disable'
    } else {
        DisableTracking
        [System.Windows.Forms.MessageBox]::Show('Log collection disabled')
        $buttonA.Text = 'Enable'
    }
})
    


$tabPageA.Controls.Add($buttonA)

# Contenuto della Pagina B
$labelB = New-Object System.Windows.Forms.Label
$labelB.Text = 'Benvenuto nella Pagina B!'
$labelB.Location = New-Object System.Drawing.Point(150, 80)
$tabPageB.Controls.Add($labelB)

# Contenuto della Pagina C
$labelC = New-Object System.Windows.Forms.Label
$labelC.Text = 'Benvenuto nella Pagina C!'
$labelC.Location = New-Object System.Drawing.Point(150, 80)
$tabPageC.Controls.Add($labelC)

# Aggiungi i TabPage al TabControl
$tabControl.TabPages.Add($tabPageA)
$tabControl.TabPages.Add($tabPageB)
$tabControl.TabPages.Add($tabPageC)

# Aggiungi il TabControl al form
$form.Controls.Add($tabControl)

# Mostra la finestra
$form.ShowDialog()
