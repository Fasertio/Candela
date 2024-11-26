$sourceFile = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
$destinationFile = "$env:USERPROFILE\Desktop\history_output.txt"

#monitora la history di PS
function Monitor_Powershell(){
    Get-Content -Path $sourceFile -Wait -Tail 0 | ForEach-Object {
        # Ottieni il timestamp corrente
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        # Crea la stringa con timestamp e riga
        $lineaConTimestamp = "[$timestamp] $_"    
        # Stampa a schermo
        Write-Host $lineaConTimestamp
        # Scrivi la riga con timestamp nel file di log (in append)
        $lineaConTimestamp | Out-File -FilePath $destinationFile -Append -Encoding UTF8
    }
}

function Monitor_CMD(){

}



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
