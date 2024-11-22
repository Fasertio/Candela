$inject = "`n`n`
#candela
$char = '0123456789'
`$string = ''
for (`$i = 0; `$i -lt `$lunghezza; `$i++) {
    `$index = Get-Random -Minimum 0 -Maximum `$char.Length
    `$string += `$char[`$index]
}

Start-Transcript -Path '`$env:USERPROFILE\Documents\Candela_collection\transcript_`$string.txt' -IncludeInvocationHeader
#candelaend"

#enable tracking
function EnableTracking (){
    $inject | Out-File -FilePath $profile -Append
}

#disable tracking
function DisableTracking(){

    # Legge il contenuto del file
    $content = Get-Content $profile
    if(-not $content){
        return $false
    }

    # Controlla se la stringa "# candela" è presente nel file
    $startIndex = $content.IndexOf("#candela")
    $endIndex = $content.IndexOf("#candelaend")

    if ($startIndex -ge 0 -and $endIndex -gt $startIndex) {
        # Rimuove le righe dalla stringa "# candela" alla stringa "#candelaend"
        $newContent = $content[0..($startIndex - 1)] + $content[($endIndex + 1)..($content.Length - 1)]

        # Scrive il nuovo contenuto nel file
        $newContent | Set-Content $filePath
    }
}

function DetectionTracking(){

    # Legge il contenuto del file
    $content = Get-Content $profile
    if(-not $content){
        return $false
    }


    # Controlla se la stringa "# candela" è presente nel file
    $startIndex = $content.IndexOf("#candela")
    $endIndex = $content.IndexOf("#candelaend")

    if ($startIndex -ge 0 -and $endIndex -gt $startIndex) {
        return $true
    }else{
        return $false
    }
}


#create folder
if(-not (Test-Path "$env:USERPROFILE\Documents\Candela_collection")){
New-Item -Path "$env:USERPROFILE\Documents\Candela_collection" -ItemType Directory
}

# Carica l'assembly di Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Crea una nuova finestra (form)
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Candela - The Red Tracker'
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.MaximizeBox = $false  # Disabilita il pulsante per massimizzare
$form.MinimizeBox = $true  # Abilita il pulsante per minimizzare
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog # Impedisce il ridimensionamento della finestra

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
        Write-Host $pressCount      
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
