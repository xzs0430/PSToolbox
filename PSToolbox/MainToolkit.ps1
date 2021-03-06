
<#

ToDo: 
	Establish limits on number of buttons based on container size
	Chocolatey installed: $env:ChocolateyInstall

#>
Clear-Host

#region Initialize environment
	$scriptRootName = "Toolkit"
	$compiled = $false
	if ($compiled) { 
		$currPath = [System.AppDomain]::CurrentDomain.BaseDirectory
	} else { 
		$scriptpath = $MyInvocation.MyCommand.Definition	#Get current script full directory
		$currPath = Split-Path $scriptpath
	}
	$settings = New-Object -TypeName XML
	$settings.Load("$currPath\config\appconfig.xml")
#endregion Initialize environment

#region XML configuration file settings
	$tab1items = $settings.appconfig.tab1.item #Button configuration for the first tab
	$msgList = $settings.appconfig.messages.message
#endregion XML configuration file settings

#region Miscellaneous variables
	$currPSVersion = $PSVersionTable.PSVersion
	$execPolicy = Get-ExecutionPolicy
#endregion

function GenerateForm {

#region Import the Assemblies
	[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
	[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
	[Reflection.Assembly]::loadwithpartialname("System.Input.MouseButtonEventHandler") | Out-Null
#endregion

#region Form variables
	$controlArray = @{}
	$controlHandlers = @{}
	$buttonWidth = 120
	$buttonHeight = 35
#endregion Form variables

#region Form Objects
	$form1 = New-Object System.Windows.Forms.Form
	$tabControl_Main = New-Object System.Windows.Forms.TabControl
	$tabPage_Tools = New-Object System.Windows.Forms.TabPage
	$tabPage_2 = New-Object System.Windows.Forms.TabPage
	$tabPage_PS = New-Object System.Windows.Forms.TabPage
	
	$panel1 = New-Object System.Windows.Forms.Panel
	$Tools1Panel = New-Object System.Windows.Forms.Panel
	
	$button3 = New-Object System.Windows.Forms.Button
	$button2 = New-Object System.Windows.Forms.Button
	$button1 = New-Object System.Windows.Forms.Button
	$btnExit = New-Object System.Windows.Forms.Button
	
	#tabControlPanel
	$btnCredMgr = New-Object System.Windows.Forms.Button
	
	#Status bar
	$statusBar1 = New-Object System.Windows.Forms.StatusBar
	$statusBarPanel1 = New-Object System.Windows.Forms.StatusBarPanel
	$statusBarPanel2 = New-Object System.Windows.Forms.StatusBarPanel
	$statusBarPanel3 = New-Object System.Windows.Forms.StatusBarPanel
	$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
	
	$textBox1 = New-Object System.Windows.Forms.Textbox
	$PSOutput = New-Object System.Windows.Forms.Textbox #output for Powershell tab actions
	$toolsOutput = New-Object System.Windows.Forms.Textbox #output for Tools tab actions
	
#endregion Form Objects

function buttonHandler($btnID) {
	#Invoke-Expression -Command $controlHandlers[$btnID]
	#todo: if executable not found then error message (errorid 10)
	$results = Start-Process $controlHandlers[$btnID]
	$textBox1.Text += $results
}

function buttons_OnLoad{
	
	param(
		$destObj
	)
	$startx = 10
	$starty = 10
	$objRoot = "B"
	$objNum = 0
	
	#Process button configuration from xml file
	#TODO: 
	foreach ($row in $tab1items) {
		$buttonID = $objRoot + $objNum
		$newButton = New-Object System.Windows.Forms.Button
		$newButton.Name = $buttonID
		$newButton.DataBindings.DefaultDataSourceUpdateMode = 0
		$System_Drawing_Point = New-Object System.Drawing.Point
		$System_Drawing_Size = New-Object System.Drawing.Size
		$System_Drawing_Point.X = $startx
		$System_Drawing_Point.Y = $starty
		$System_Drawing_Size.Height = $buttonHeight
		$System_Drawing_Size.Width = $buttonWidth
		$newButton.Location = $System_Drawing_Point
		$newButton.Size = $System_Drawing_Size
		$newButton.TabIndex = 0
		$newButton.Text = $row.Text #XML node attribute Text
		$newButton.UseVisualStyleBackColor = $True
		
		if ($row.HasAttribute("envvar")) {
			$envvar = $row.GetAttribute("envvar")
			if ($envvar -eq 'COMSPEC') {	
				$envval = (Get-Item "Env:\$envvar").value
				$cmd = $envval
			} elseif ($envvar -eq 'PSHOME') {
				$cmd = "$PSHome\powershell.exe"
			}
		} else {
			$cmd = $row.InnerText
			$textBox1.Text += $cmd
		}
		$controlHandlers.Add($buttonID, $cmd)
		$newButton.Add_click({buttonHandler $this.Name})
	
		$destObj.Controls.Add($newButton)
		
		$controlArray += @{$buttonID=$row.InnerText}

		$starty = $starty + 40
		$objNum = $objNum + 1
	}
}

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
#Provide Custom Code for events specified in PrimalForms.
$button3_OnClick= 
{
#TODO: Place custom script here

}

$button1_OnClick= 
{
#TODO: Place custom script here
	
}

$btnExit_OnClick = {
	$form1.Close()
}

$btnTestHandler_OnClick= 
{
	

}

$btnCredMgr_OnClick = {
	
}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$form1.WindowState = $InitialFormWindowState
	buttons_OnLoad $Tools1Panel
}

#----------------------------------------------
#region Form Code

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 570
$System_Drawing_Size.Width = 1000
$form1.ClientSize = $System_Drawing_Size
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.Name = "form1"
$form1.Text = "Toolkit"

$textBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 16
$System_Drawing_Point.Y = 61
$textBox1.Location = $System_Drawing_Point
$textBox1.Multiline = $True
$textBox1.Name = "textBox1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 77
$System_Drawing_Size.Width = 831
$textBox1.Size = $System_Drawing_Size

# Start main tab section
$tabControl_Main.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 12
$System_Drawing_Point.Y = 156
$tabControl_Main.Location = $System_Drawing_Point
$tabControl_Main.Name = "tabControl1"
$tabControl_Main.SelectedIndex = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 386
$System_Drawing_Size.Width = 725
$tabControl_Main.Size = $System_Drawing_Size
$tabControl_Main.TabIndex = 1

$tabPage_Tools.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 4
$System_Drawing_Point.Y = 26
$tabPage_Tools.Location = $System_Drawing_Point
$tabPage_Tools.Name = "tabPage_Tools"
$System_Windows_Forms_Padding = New-Object System.Windows.Forms.Padding
$System_Windows_Forms_Padding.All = 3
$System_Windows_Forms_Padding.Bottom = 3
$System_Windows_Forms_Padding.Left = 3
$System_Windows_Forms_Padding.Right = 3
$System_Windows_Forms_Padding.Top = 3
$tabPage_Tools.Padding = $System_Windows_Forms_Padding
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 356
$System_Drawing_Size.Width = 225
$tabPage_Tools.Size = $System_Drawing_Size
$tabPage_Tools.TabIndex = 0
$tabPage_Tools.Text = "Tools"
$tabPage_Tools.UseVisualStyleBackColor = $True
$tabPage_Tools.Tool

$tabPage_2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 4
$System_Drawing_Point.Y = 26
$tabPage_2.Location = $System_Drawing_Point
$tabPage_2.Name = "tabPage2"
$System_Windows_Forms_Padding = New-Object System.Windows.Forms.Padding
$System_Windows_Forms_Padding.All = 3
$System_Windows_Forms_Padding.Bottom = 3
$System_Windows_Forms_Padding.Left = 3
$System_Windows_Forms_Padding.Right = 3
$System_Windows_Forms_Padding.Top = 3
$tabPage_2.Padding = $System_Windows_Forms_Padding
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 356
$System_Drawing_Size.Width = 225
$tabPage_2.Size = $System_Drawing_Size
$tabPage_2.TabIndex = 1
$tabPage_2.Text = "tabPage2"
$tabPage_2.UseVisualStyleBackColor = $True

$tabPage_PS.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 4
$System_Drawing_Point.Y = 26
$tabPage_PS.Location = $System_Drawing_Point
$tabPage_PS.Name = "tabPage3"
$System_Windows_Forms_Padding = New-Object System.Windows.Forms.Padding
$System_Windows_Forms_Padding.All = 3
$System_Windows_Forms_Padding.Bottom = 3
$System_Windows_Forms_Padding.Left = 3
$System_Windows_Forms_Padding.Right = 3
$System_Windows_Forms_Padding.Top = 3
$tabPage_PS.Padding = $System_Windows_Forms_Padding
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 356
$System_Drawing_Size.Width = 225
$tabPage_PS.Size = $System_Drawing_Size
$tabPage_PS.TabIndex = 1
$tabPage_PS.Text = "Powershell"
$tabPage_PS.UseVisualStyleBackColor = $True

#end of main tab section                  

$panel1.BorderStyle = 2
$panel1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 250
$System_Drawing_Point.Y = 183
$panel1.Location = $System_Drawing_Point
$panel1.Name = "panel1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 100
$System_Drawing_Size.Width = 150
$panel1.Size = $System_Drawing_Size
$panel1.TabIndex = 2

$Tools1Panel.BorderStyle = 2
$Tools1Panel.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 10
$System_Drawing_Point.Y = 10
$Tools1Panel.Location = $System_Drawing_Point
$Tools1Panel.Name = "Tools1Panel"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 350
$System_Drawing_Size.Width = 150
$Tools1Panel.Size = $System_Drawing_Size
$Tools1Panel.TabIndex = 2

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 165
$System_Drawing_Point.Y = 10
$PSOutput.Location = $System_Drawing_Point
$PSOutput.Name = "Output"
$PSOutput.Multiline = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 310
$System_Drawing_Size.Width = 540
$PSOutput.Size = $System_Drawing_Size

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 165
$System_Drawing_Point.Y = 10
$toolsOutput.Location = $System_Drawing_Point
$toolsOutput.Name = "toolsOutput"
$toolsOutput.Multiline = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 310
$System_Drawing_Size.Width = 540
$toolsOutput.Size = $System_Drawing_Size

$button3.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 4
$System_Drawing_Point.Y = 4
$button3.Location = $System_Drawing_Point
$button3.Name = "button3"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$button3.Size = $System_Drawing_Size
$button3.TabIndex = 0
$button3.Text = "button3"
$button3.UseVisualStyleBackColor = $True
$button3.add_Click($button3_OnClick)

$button2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 893
$System_Drawing_Point.Y = 37
$button2.Location = $System_Drawing_Point
$button2.Name = "button2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$button2.Size = $System_Drawing_Size
$button2.TabIndex = 1
$button2.Text = "button2"
$button2.UseVisualStyleBackColor = $True
$button2.add_Click($button2_OnClick)

$button1.DataBindings.DefaultDataSourceUpdateMode = 0

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 893
$System_Drawing_Point.Y = 7
$button1.Location = $System_Drawing_Point
$button1.Name = "button1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$button1.Size = $System_Drawing_Size
$button1.TabIndex = 0
$button1.Text = "button1"
$button1.UseVisualStyleBackColor = $True
$button1.add_Click($button1_OnClick)

$btnExit.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 870
$System_Drawing_Point.Y = 7
$btnExit.Location = $System_Drawing_Point
$btnExit.Name = "btnExit"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = $buttonHeight
$System_Drawing_Size.Width = $buttonWidth
$btnExit.Size = $System_Drawing_Size
$btnExit.TabIndex = 0
$btnExit.Text = "Exit"
$btnExit.UseVisualStyleBackColor = $True
$btnExit.add_Click($btnExit_OnClick)

#tabControlPanel buttons 
	$btnCredMgr.DataBindings.DefaultDataSourceUpdateMode = 0

	$System_Drawing_Point = New-Object System.Drawing.Point
	$System_Drawing_Point.X = 12
	$System_Drawing_Point.Y = 12
	$btnCredMgr.Location = $System_Drawing_Point
	$btnCredMgr.Name = "button1"
	$System_Drawing_Size = New-Object System.Drawing.Size
	$System_Drawing_Size.Height = $buttonHeight
	$System_Drawing_Size.Width = $buttonWidth
	$btnCredMgr.Size = $System_Drawing_Size
	$btnCredMgr.TabIndex = 0
	$btnCredMgr.Text = "Cred Manager"
	$btnCredMgr.UseVisualStyleBackColor = $True
	$btnCredMgr.add_Click($btnCredMgr_OnClick)

#end tabControlPanel buttons

#region Statusbar
$statusBar1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = 548
$statusBar1.Location = $System_Drawing_Point
$statusBar1.Name = "statusBar1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 22
$System_Drawing_Size.Width = 1022
$statusBar1.Panels.Add($statusBarPanel1)|Out-Null
$statusBar1.Panels.Add($statusBarPanel2)|Out-Null
$statusBar1.Panels.Add($statusBarPanel3)|Out-Null
$statusBar1.ShowPanels = $True
$statusBar1.Size = $System_Drawing_Size
$statusBar1.TabIndex = 0
#$statusBar1.add_PanelClick($handler_statusBar1_PanelClick)
$statusBarPanel1.Name = "statusBarPanel1"
$statusBarPanel1.Text = "PowerShell v $currPSVersion"
$statusBarPanel1.Width = 150
$statusBarPanel2.Name = "statusBarPanel2"
$statusBarPanel2.Text = "Execution Policy: $execPolicy"
$statusBarPanel2.Width = 700
$statusBarPanel3.Alignment = 'Right'
$statusBarPanel3.Name = "statusBarPanel3"
$statusBarPanel3.Text = "statusBarPanel3"
$statusBarPanel3.Width = 150
$statusBarPanel3.ToolTipText = $statusBarPanel3.Name
#endregion Statusbar

#Add to Form
	$tabControl_Main.Controls.Add($tabPage_Tools)
	$tabControl_Main.Controls.Add($tabPage_2)
	$tabControl_Main.Controls.Add($tabPage_PS)
	
	$tabPage_Tools.Controls.Add($Tools1Panel)
	$tabPage_Tools.Controls.Add($toolsOutput)
	#$Tools1Panel.Controls.Add(
	
	$tabPage_PS.Controls.Add($PSOutput)
	#$form1.Controls.Add($panel1)
	
	#$panel1.Controls.Add($button3)
	
	$tabPage_Tools.Controls.Add($button1)
	$tabPage_Tools.Controls.Add($button2)

	$form1.Controls.Add($tabControl_Main)	
	$form1.Controls.Add($btnExit)
	$form1.Controls.Add($statusBar1)	
	$form1.Controls.Add($textBox1)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm
