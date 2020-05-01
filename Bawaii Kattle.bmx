' Code source du jeu Bawaii Kattle
' Copyright (C) TME/WTR - 04/2009
' Contact : tme@mail.com
'
' Ce programme est libre, vous pouvez le redistribuer et/ou le modifier selon les termes de la Licence Publique Generale GNU publiee par la Free Software Foundation (version 2 ou bien toute autre version ulterieure choisie par vous).
'
' Ce programme est distribue car potentiellement utile, mais SANS AUCUNE GARANTIE, ni explicite ni implicite, y compris les garanties de commercialisation ou d'adaptation dans un but specifique. Reportez-vous à la Licence Publique Generale GNU pour plus de details.
'
' Vous devez avoir reçu une copie de la Licence Publique Generale GNU en même temps que ce programme ; si ce n'est pas le cas, ecrivez à la Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, États-Unis. 

' Garbage collector parameters : Automatic - activated
GCSetMode(1)

WriteStdout("*** BAWAII KATTLE - 04/2009 - TME/WTR ***"+Chr(13)+Chr(10))
WriteStdout("*** Distributed under GPL ***"+Chr(13)+Chr(10))
WriteStdout("*** Contact Free Software Foundation for more details ***"+Chr(13)+Chr(10))
WriteStdout("*** If you have comments about this game or if you want to help, please write to tme@mail.com ***"+Chr(13)+Chr(10))

' 640*480 32 bits fullscreen mode
Graphics 640,480,32
' 640*480 windowed mode
' Graphics 640,480,0
HideMouse()
SetBlend ALPHABLEND
SetAlpha 1.0

' Custom types definition
Type TCharacter
	Field strName:String[20]
	Field iCuteness:Int[20]
	Field iStrength:Int[20]
	Field iIntelligence:Int[20]
	Field iWisdom:Int[20]
	Field iMana:Int[20]
	Field strSpecial:String[20]
	Field bIsSpecialActivated[20]
	Field iLifePoints:Int[20]
End Type

Type TGraphicalObject
	Field iID:Int
	Field iColorR:Int
	Field iColorG:Int
	Field iColorB:Int
	Field iPosX:Int
	Field iPosY:Int
	Field iHeight:Int
	Field iWidth:Int
	Field iRotation:Int
	Field iSpeed:Int
	Field iCurrentFrame:Int
	Field iCounter:Int
	Field strType:String
	Field strName:String
	Field fAlpha:Float
	
	Function CreateGO:TGraphicalObject(p_iID:Int,p_iColorR:Int,p_iColorG:Int,p_iColorB:Int,p_iPosX:Int,p_iPosY:Int,p_iHeight:Int,p_iWidth:Int,p_iRotation:Int,p_iSpeed:Int,p_iCurrentFrame:Int,p_iCounter:Int,p_strType:String,p_strName:String,p_fAlpha:Float)
		Local GraphicalObject:TGraphicalObject = New TGraphicalObject
		GraphicalObject.iID=p_iID
		GraphicalObject.iColorR=p_iColorR
		GraphicalObject.iColorG=p_iColorG
		GraphicalObject.iColorB=p_iColorB
		GraphicalObject.iPosX=p_iPosX
		GraphicalObject.iPosY=p_iPosY
		GraphicalObject.iHeight=p_iHeight
		GraphicalObject.iWidth=p_iWidth
		GraphicalObject.iRotation=p_iRotation
		GraphicalObject.iSpeed=p_iSpeed
		GraphicalObject.iCurrentFrame=p_iCurrentFrame
		GraphicalObject.iCounter=p_iCounter
		GraphicalObject.strType=p_strType
		GraphicalObject.strName=p_strName
		GraphicalObject.fAlpha=p_fAlpha
		Return GraphicalObject
	End Function
End Type

' Variables declaration and initialization
' Integers
Global x:Int=GraphicsWidth () / 2
Global y:Int=GraphicsHeight () / 2
Global iCombatMode:Int=0
Global iPlayer1SelectedCharacter:Int=0
Global iPlayer2SelectedCharacter:Int=0
Global iRoundsCntr:Int=0
Global iCurrentRound:Int=0
Global iDemoModeCntr:Int=0
Global iRound1Winner:Int=0
Global iRound2Winner:Int=0
Global iRound3Winner:Int=0
Global iWinner:Int=0
' Strings
Const VERSION:String="1.0.0"	' Longueur de la chaine : 5 caracteres maximum.
' Arrays
Global arCharacters:TCharacter=New TCharacter
arCharacters.strName=["Symetrie","DDT","Hecate","Lava","Gizmo","Activius","Bubble","Nekale","Mega Burger","Rodolphe","Aenae","Netoile","Laura","Flaoua","Cross","Evil Framboise","Ultramarine","Mo","Shaman","Shibuya"]
arCharacters.iCuteness=[10,9,6,7,5,2,1,5,2,8,4,10,5,8,6,7,7,7,4,3]
arCharacters.iStrength=[6,5,7,8,4,9,1,6,7,2,6,5,7,3,8,7,7,7,8,4]
arCharacters.iIntelligence=[5,4,7,7,8,6,2,10,5,5,6,3,6,4,8,7,7,8,10,2]
arCharacters.iWisdom=[10,8,5,5,10,3,1,9,1,10,7,4,6,10,10,5,4,5,7,4]
arCharacters.iMana=[8,7,8,9,6,4,10,8,7,7,3,6,4,8,7,3,2,8,10,6]
arCharacters.strSpecial=["Heal","Heal","Protect","Convert","Protect","Protect","Reflect","Protect","Block","Heal","Protect","Protect","Block","Heal","Protect","Heal","Heal","Reflect","Convert","Reflect"]
arCharacters.bIsSpecialActivated=[False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False]
' arCharacters.iLifePoints=[40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40]
arCharacters.iLifePoints=[20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20]
Global arPlayer1Score[]=[9,9,9,9,9,9,9,9,9,9,9,9]
Global arPlayer2Score[]=[9,9,9,9,9,9,9,9,9,9,9,9]
Global arPlayer1Team[]=[99,99,99]
Global arPlayer2Team[]=[99,99,99]
' Booleans
' 0=true // 1=false
Global bPlayer1Turn:Byte=True
Global bPlayer2Turn:Byte=False
Global bQuitGame:Byte=False
Global bIsCheatCodeLOBELYAActive:Byte=False

WriteStdout("    <Variables are correctly declared and initialized>    "+Chr(13)+Chr(10))

' Images
Global bmWinnerScreen:TImage
Global bmWarrior1:TImage
Global bmWarrior2:TImage

' Music
Rem
Global sample_test_son=LoadSound("./sound/neo.wav",False)
consoleRefresh("Loading ./sound/neo.wav")
End Rem

' Show allocated memory
' consoleRefresh("Allocated memory : "+GCMemAlloced()+" bytes.",0)

gameInit()

' Main loop
While bQuitGame=False
	If bQuitGame=False Then mainMenu()
	' Porcin - TO REMOVE
	iRoundsCntr=0
	' End Porcin
	If bQuitGame=False Then teamCreation()
	' combatManagement()
	While iWinner=0 And bQuitGame=False
		iRoundsCntr:+1
		combatManagement()
	Wend
	If bQuitGame=False Then displayScores()
	If bQuitGame=False Then displayWinner(iWinner)
	If bQuitGame=False Then gameInit()
Wend

gameStop()

End


' ========================================================================================================


Function progressiveMask(bmBackgroundPicture:TImage, fStartAt:Float, fStopAt:Float, strMaskMode:String)
	' MODE : down=Le rideau noir est de moins en moins opaque, devoilant progressivement l'image qui est en dessous
	'        up=Le rideau noir est de plus en plus opaque, masquant progressivement l'image qui est en dessous

	' Declaration et initialisation des variables locales
	' Les reels
	Local fMaskOpacityCntr:Float=0.0
	
	WriteStdout("    <progressiveMask : IN>    "+Chr(13)+Chr(10))
	fMaskOpacityCntr=fStartAt
	
	If strMaskMode="down" Then
		While fMaskOpacityCntr>fStopAt
			fMaskOpacityCntr:-0.05
			SetAlpha 1.0
			DrawImage(bmBackgroundPicture,0,0)
			SetAlpha fMaskOpacityCntr
			SetColor 0,0,0
			DrawRect 0,0,640,480
			SetColor 255,255,255
			' displayText(GCMemAlloced(),"",255,255,255,1,0,0,0,560,460,0)
			Flip(sync=1);Cls
			Delay 5
		Wend
	Else
		If strMaskMode="up" Then
			While fMaskOpacityCntr<fStopAt
				fMaskOpacityCntr:+0.05
				SetAlpha 1.0
				DrawImage(bmBackgroundPicture,0,0)
				SetAlpha fMaskOpacityCntr
				SetColor 0,0,0
				DrawRect 0,0,640,480
				SetColor 255,255,255
				' displayText(GCMemAlloced(),"",255,255,255,1,0,0,0,560,460,0)
				Flip(sync=1);Cls
				Delay 5
			Wend
		EndIf
	EndIf
	
	SetBlend ALPHABLEND
	SetAlpha 1.0
	WriteStdout("    <progressiveMask : OUT>    "+Chr(13)+Chr(10))
End Function

Function consoleRefresh(strTextToDisplay:String, iDisplayDuration:Int)
	displayText("****************************************************************","",255,255,255,0,0,0,0,10,10,0)
	displayText("*                                                              *","",255,255,255,0,0,0,0,10,20,0)
	displayText("*                        Bawaii Kattle "+VERSION+"                   *","",255,255,255,0,0,0,0,10,30,0)
	displayText("*                                                              *","",255,255,255,0,0,0,0,10,40,0)
	displayText("*                     04/2009 -- TME/WoodTower                 *","",255,255,255,0,0,0,0,10,50,0)
	displayText("*                                                              *","",255,255,255,0,0,0,0,10,60,0)
	displayText("****************************************************************","",255,255,255,0,0,0,0,10,70,0)
	displayText(strTextToDisplay,"",255,255,255,0,0,0,0,10,100,0)
	' displayText(GCMemAlloced(),"",255,255,255,1,0,0,0,560,460,0)
	Flip(sync=1);Cls
	WriteStdout("    <consoleRefresh: "+strTextToDisplay+">    "+Chr(13)+Chr(10))
	Delay iDisplayDuration
End Function


Function mainMenu()
	WriteStdout("    <mainMenu: IN>    "+Chr(13)+Chr(10))
	' Declaration et initialisation des variables locales
	' Les entiers
	Local iCompteurYbmNeko6454:Int=250
	' Les booleens
	Local bQuitterMenuPrincipal:Byte=False
	Local bSelectionModifiee:Byte=False
	' Strings
	Local strCheatCodeString:String=""
	' Les images
	' Local bmEcranTitre3:TImage=LoadImage("./pictures/ecran_titre3.png",FILTERED=-1)
	Const TOLOADTEST:String="./pictures/ecran_titre3.png"
	Local bmEcranTitre3:TImage=LoadImage(TOLOADTEST,FILTERED=-1)
	Local bmNeko6454:TImage=LoadImage("./pictures/neko6454.png",FILTERED=-1)
	Local bmComputedPicture1=CreateImage(640,480,DYNAMICIMAGE)
	MidHandleImage bmNeko6454
	
	
	' Creation de bmComputedPicture1
	Cls
	DrawImage(bmEcranTitre3,0,0)
	DrawImage(bmNeko6454,190,iCompteurYbmNeko6454)
	GrabImage(bmComputedPicture1,0,0)
	
	' On affiche le menu principal
	' progressiveMask(bmEcranTitre3, 1.0, 0.0, "down")
	progressiveMask(bmComputedPicture1, 1.0, 0.0, "down")
	
	' Vidage du tampon clavier
	FlushKeys()
	
	' Boucle d'attente du menu principal
	' Pour forcer l'affichage du menu lors de l'entree dans la fonction
	bSelectionModifiee=True
	While bQuitterMenuPrincipal=False
		' Incrementation du compteur relatif au mode DEMO
		iDemoModeCntr:+1
		If iDemoModeCntr=6000 Then
			' Lancement du mode DEMO
			progressiveMask(bmEcranTitre3, 0.0, 1.0, "up")
			modeDemo()
			bSelectionModifiee=True
		EndIf
		' Affichage du fond et du menu si necessaire
		If bSelectionModifiee=True Then
			bSelectionModifiee=False
			DrawImage(bmEcranTitre3,0,0)
			DrawImage(bmNeko6454,190,iCompteurYbmNeko6454)
			GrabImage(bmComputedPicture1,0,0)
			' displayText(GCMemAlloced(),"",255,255,255,1,0,0,0,560,460,0)
			displayText("v20090409","",0,0,0,0,0,0,0,500,460,0)
			Flip(sync=1)
			If strCheatCodeString="LOBELYA" Then
				strCheatCodeString=""
				cheatCodeActivation("LOBELYA")
				bIsCheatCodeLOBELYAActive=True
				bSelectionModifiee=True
			EndIf
			Cls
		EndIf
		
		Delay 5
		
		' Si appui sur ENTER, redirection vers combatManagement()
		If KeyHit(KEY_ENTER) Then
			If iCompteurYbmNeko6454=250 Then
				' 1 player
				iCombatMode=1
				bQuitterMenuPrincipal=True
			EndIf 
			If iCompteurYbmNeko6454=335 Then
				' 2 players
				iCombatMode=2
				bQuitterMenuPrincipal=True
			EndIf
			If iCompteurYbmNeko6454=420 Then
				' Quit game
				iCombatMode=0
				bQuitterMenuPrincipal=True
				bQuitGame=True
			EndIf
		EndIf
		If KeyHit(KEY_UP) Then
			iCompteurYbmNeko6454:-85
			If iCompteurYbmNeko6454<250 Then iCompteurYbmNeko6454=420
			bSelectionModifiee=True
		EndIf
		If KeyHit(KEY_DOWN) Then
			iCompteurYbmNeko6454:+85
			If iCompteurYbmNeko6454>420 Then iCompteurYbmNeko6454=250
			bSelectionModifiee=True
		EndIf
		If KeyHit(KEY_1) Then
			iCombatMode=1
			bQuitterMenuPrincipal=True
		EndIf
		If KeyHit(KEY_2) Then
			iCombatMode=2
			bQuitterMenuPrincipal=True
		EndIf
		If KeyHit(KEY_3) Then
			iCombatMode=0
			bQuitterMenuPrincipal=True
			bQuitGame=True
		EndIf
		If KeyHit(KEY_ESCAPE) Then
			bQuitterMenuPrincipal=True
			bQuitGame=True
		EndIf
		If KeyHit(KEY_A) Then strCheatCodeString=strCheatCodeString+"A"
		If KeyHit(KEY_B) Then strCheatCodeString=strCheatCodeString+"B"
		If KeyHit(KEY_C) Then strCheatCodeString=strCheatCodeString+"C"
		If KeyHit(KEY_D) Then strCheatCodeString=strCheatCodeString+"D"
		If KeyHit(KEY_E) Then strCheatCodeString=strCheatCodeString+"E"
		If KeyHit(KEY_F) Then strCheatCodeString=strCheatCodeString+"F"
		If KeyHit(KEY_G) Then strCheatCodeString=strCheatCodeString+"G"
		If KeyHit(KEY_H) Then strCheatCodeString=strCheatCodeString+"H"
		If KeyHit(KEY_I) Then strCheatCodeString=strCheatCodeString+"I"
		If KeyHit(KEY_J) Then strCheatCodeString=strCheatCodeString+"J"
		If KeyHit(KEY_K) Then strCheatCodeString=strCheatCodeString+"K"
		If KeyHit(KEY_L) Then strCheatCodeString=strCheatCodeString+"L"
		If KeyHit(KEY_M) Then strCheatCodeString=strCheatCodeString+"M"
		If KeyHit(KEY_N) Then strCheatCodeString=strCheatCodeString+"N"
		If KeyHit(KEY_O) Then strCheatCodeString=strCheatCodeString+"O"
		If KeyHit(KEY_P) Then strCheatCodeString=strCheatCodeString+"P"
		If KeyHit(KEY_Q) Then strCheatCodeString=strCheatCodeString+"Q"
		If KeyHit(KEY_R) Then strCheatCodeString=strCheatCodeString+"R"
		If KeyHit(KEY_S) Then strCheatCodeString=strCheatCodeString+"S"
		If KeyHit(KEY_T) Then strCheatCodeString=strCheatCodeString+"T"
		If KeyHit(KEY_U) Then strCheatCodeString=strCheatCodeString+"U"
		If KeyHit(KEY_V) Then strCheatCodeString=strCheatCodeString+"V"
		If KeyHit(KEY_W) Then strCheatCodeString=strCheatCodeString+"W"
		If KeyHit(KEY_X) Then strCheatCodeString=strCheatCodeString+"X"
		If KeyHit(KEY_Y) Then strCheatCodeString=strCheatCodeString+"Y"
		If KeyHit(KEY_Z) Then strCheatCodeString=strCheatCodeString+"Z"
		If Len(strCheatCodeString)>32 Then strCheatCodeString=""
		If strCheatCodeString="LOBELYA" Then
			bSelectionModifiee=True
		EndIf
	Wend
	
	progressiveMask(bmComputedPicture1, 0.0, 1.0, "up")
	WriteStdout("    <mainMenu: OUT>    "+Chr(13)+Chr(10))
End Function

Function combatManagement()
	WriteStdout("    <combatManagement: IN>    "+Chr(13)+Chr(10))
	' Declaration et initialisation des variables locales
	' Les entiers
	Local iPlayer1AttackNumber:Int=0
	Local iPlayer2AttackNumber:Int=0
	Local iBackgroundPic1PosX:Int=0
	Local iBackgroundPic2PosX:Int=1280
	Local iDiceScore:Int=0
	Local iGreyShadowX1Pos:Int=0
	Local iChosenEntry:Int=0
	Local iCurrentMenuLevel:Int=0
	Local iCombatStep:Int=0
	Local iCombatStepInternalCntr:Int=0
	Local iCurrentScreenBackgroundColor:Int=0
	Local iCurrentRoundWinner:Int=0
	Local iP1Victories:Int=0
	Local iP2Victories:Int=0
	Local iSpecialScore:Int=0
	' Les booleens
	Local bIsEntryChosen:Byte=False
	Local bIsActionChosen:Byte=False
	Local bIsCombatActionOver:Byte=True
	Local bFlashScreenBackground:Byte=False
	Local bIsCurrentActionAStealingAttempt:Byte=False
	Local bIsStealAttemptSuccessful:Byte=False
	' Les images
	Local bmEcranCombat:TImage=LoadImage("./pictures/ecran_combat.png",FILTERED=-1)
	Local bmEcranScores:TImage=LoadImage("./pictures/ecran_scores.png",FILTERED=-1)
	Local bmComputedPicture1:TImage=CreateImage(640,480,DYNAMICIMAGE)
	Local bmComputedPicture2:TImage=CreateImage(640,480,DYNAMICIMAGE)
	Local bmComputedPicture3:TImage=CreateImage(640,480,DYNAMICIMAGE)
	Local bmMenuCombat:TImage=LoadImage("./pictures/menu_combat.png",FILTERED=-1)
	Local bmIconHeal:TImage=LoadImage("./pictures/icon_heal.png",FILTERED=-1)
	Local bmIconProtect:TImage=LoadImage("./pictures/icon_protect.png",FILTERED=-1)
	Local bmIconConvert:TImage=LoadImage("./pictures/icon_convert.png",FILTERED=-1)
	Local bmIconReflect:TImage=LoadImage("./pictures/icon_reflect.png",FILTERED=-1)
	Local bmIconBlock:TImage=LoadImage("./pictures/icon_block.png",FILTERED=-1)
	Local bmRougeJaune:TImage=LoadImage("./pictures/rouge-jaune.png",FILTERED=-1)
	Local bmTextBox:TImage=LoadImage("./pictures/textbox.png",FILTERED=-1)
	Local bmBottomBar:TImage=LoadImage("./pictures/ecran_combat_bottom.png",FILTERED=-1)
	' Les chaines
	Local strPlayerName:String=""
	Local strAttackType:String=""
	Local strIconType:String=""
	' Timers
	Local tmrTimer50:TTimer=CreateTimer(50)
	' Lists
	Local GOList:TList = New TList
	' Custom types
	Local CurrentGO:TGraphicalObject
	
	' Players current character update
	WriteStdout("Players current character update"+Chr(13)+Chr(10))
	While bIsCurrentRoundFound=False
		Select iCurrentRound
			Case 0
				If iRound1Winner=0 Then
					bIsCurrentRoundFound=True
				Else
					iCurrentRound:+1
				EndIf
			Case 1
				If iRound2Winner=0 Then
					bIsCurrentRoundFound=True
				Else
					iCurrentRound:+1
				EndIf
			Case 2
				If iRound3Winner=0 Then
					bIsCurrentRoundFound=True
				Else
					iCurrentRound=0
				EndIf
		End Select
	Wend
	WriteStdout("iRoundsCntr="+iRoundsCntr+" -- iCurrentRound="+iCurrentRound+Chr(13)+Chr(10))
	iPlayer1SelectedCharacter=arPlayer1Team[iCurrentRound]
	iPlayer2SelectedCharacter=arPlayer2Team[iCurrentRound]
	
	' Loading characters pictures
	WriteStdout("Loading characters pictures"+Chr(13)+Chr(10))
	bmWarrior1=LoadImage("./pictures/character"+iPlayer1SelectedCharacter+"_portrait.png",FILTERED=-1)
	bmWarrior2=LoadImage("./pictures/character"+iPlayer2SelectedCharacter+"_portrait.png",FILTERED=-1)
	
	' Affichage des opposants
	displayOpponents()
	
	' Vidage du tampon clavier
	FlushKeys()
	
	' Creation of bmComputedPicture1
	WriteStdout("Creation of bmComputedPicture1"+Chr(13)+Chr(10))
	Cls
	DrawImage(bmEcranCombat,0,0)
	displayText(">> "+arCharacters.strName[iPlayer1SelectedCharacter]+" ("+arCharacters.iLifePoints[iPlayer1SelectedCharacter]+")","ichigo20",255,255,255,1,0,0,0,20,270,0)
	displayText(">> "+arCharacters.strName[iPlayer2SelectedCharacter]+" ("+arCharacters.iLifePoints[iPlayer2SelectedCharacter]+")","ichigo20",255,255,255,1,0,0,0,390,270,0)
	DrawImage(bmWarrior1,0,15)
	DrawImage(bmWarrior2,400,15)
	' Characters caracteristics
	' Player 1 (values)
	If bPlayer1Turn=True Then
		displayText(arCharacters.iCuteness[iPlayer1SelectedCharacter],"",255,255,255,1,0,0,0,222,315,0)
		displayText(arCharacters.iStrength[iPlayer1SelectedCharacter],"",255,255,255,1,0,0,0,222,350,0)
		displayText(arCharacters.iIntelligence[iPlayer1SelectedCharacter],"",255,255,255,1,0,0,0,222,385,0)
		displayText(arCharacters.iWisdom[iPlayer1SelectedCharacter],"",255,255,255,1,0,0,0,222,420,0)
		displayText(arCharacters.iMana[iPlayer1SelectedCharacter],"",255,255,255,1,0,0,0,222,455,0)
		' Player 2 (?)
		displayText("?","",255,255,255,1,0,0,0,570,315,0)
		displayText("?","",255,255,255,1,0,0,0,570,350,0)
		displayText("?","",255,255,255,1,0,0,0,570,385,0)
		displayText("?","",255,255,255,1,0,0,0,570,420,0)
		displayText("?","",255,255,255,1,0,0,0,570,455,0)
	Else
		' Player 1 (?)
		displayText("?","",255,255,255,1,0,0,0,222,315,0)
		displayText("?","",255,255,255,1,0,0,0,222,350,0)
		displayText("?","",255,255,255,1,0,0,0,222,385,0)
		displayText("?","",255,255,255,1,0,0,0,222,420,0)
		displayText("?","",255,255,255,1,0,0,0,222,455,0)
		' Player 2 (values)
		displayText(arCharacters.iCuteness[iPlayer2SelectedCharacter],"",255,255,255,1,0,0,0,570,315,0)
		displayText(arCharacters.iStrength[iPlayer2SelectedCharacter],"",255,255,255,1,0,0,0,570,350,0)
		displayText(arCharacters.iIntelligence[iPlayer2SelectedCharacter],"",255,255,255,1,0,0,0,570,385,0)
		displayText(arCharacters.iWisdom[iPlayer2SelectedCharacter],"",255,255,255,1,0,0,0,570,420,0)
		displayText(arCharacters.iMana[iPlayer2SelectedCharacter],"",255,255,255,1,0,0,0,570,455,0)
	EndIf
	' Combat main menu
	If bPlayer1Turn = True Then
		iGreyShadowX1Pos=320
	Else
		iGreyShadowX1Pos=0
	EndIf
	' Grey shadow
	SetAlpha 0.7
	SetColor 0,0,0
	DrawRect iGreyShadowX1Pos,0,320,480
	SetColor 255,255,255
	SetAlpha 1.0
	' Menu background picture
	DrawImage(bmMenuCombat,iGreyShadowX1Pos,0)
	If bPlayer1Turn=True Then
		'Player 1
		displayText("Player 1","chick60",255,255,255,1,0,0,0,390,10,0)
		displayText("Choose an action by pressing","",255,255,255,1,0,0,0,360,410,0)
		displayText("key 0 to 9.","",255,255,255,1,0,0,0,360,422,0)
		' displayText("-= ALPHA =-","",255,0,0,1,0,255,0,550,460,0)
	Else
		If bPlayer2Turn=True And iCombatMode=1 Then
			'CPU
			displayText("CPU","chick60",255,255,255,1,0,0,0,110,10,0)
			' displayText("-= ALPHA =-","",255,0,0,1,0,255,0,550,460,0)
		EndIf
		If bPlayer2Turn=True And iCombatMode=2 Then
			'Player 2
			displayText("Player 2","chick60",255,255,255,1,0,0,0,75,10,0)
			displayText("Choose an action by pressing","",255,255,255,1,0,0,0,40,410,0)
			displayText("key 0 to 9.","",255,255,255,1,0,0,0,40,422,0)
			' displayText("-= ALPHA =-","",255,0,0,1,0,255,0,550,460,0)
		EndIf
	EndIf
	' Enregistrement de bmComputedPicture1
	GrabImage(bmComputedPicture1,0,0)
	
	' Affichage de l'ecran de combat definitif
	Cls
	DrawImage(bmComputedPicture1,0,0)
	Flip(sync=1)
	
	iCurrentMenuLevel=1
	bIsActionChosen=False
	WriteStdout("Action selection loop"+Chr(13)+Chr(10))
	WriteStdout("Waiting for keypress"+Chr(13)+Chr(10))
	While bIsActionChosen=False And bQuitGame=False
		iChosenEntry=99
		bIsEntryChosen=False
		Cls
		DrawImage(bmComputedPicture1,0,0)
		Select iCurrentMenuLevel
			Case 1
				displayText("1 FIGHT","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,100,0)
				displayText("2 STEAL","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,130,0)
				If (bPlayer1Turn=True And arCharacters.bIsSpecialActivated[iPlayer1SelectedCharacter]=False) Or (bPlayer2Turn=True And arCharacters.bIsSpecialActivated[iPlayer2SelectedCharacter]=False) Then
					displayText("3 SPECIAL","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,160,0)
				Else
					If (bPlayer1Turn=True And arCharacters.bIsSpecialActivated[iPlayer1SelectedCharacter]=True) Or (bPlayer2Turn=True And arCharacters.bIsSpecialActivated[iPlayer2SelectedCharacter]=True) Then
						displayText("3 SPECIAL","ichigo20",80,79,77,1,0,0,0,iGreyShadowX1Pos+20,160,0)
					EndIf
				EndIf
				' displayText("4 ITEM","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,190,0)
				' displayText("5 MAGIC","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,220,0)
				displayText(" ---- ","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,250,0)
				displayText("0 PASS","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,280,0)
				' displayText("-= ALPHA =-","",255,0,0,1,0,255,0,550,460,0)
			Case 2
				displayText("1 CUTENESS","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,100,0)
				displayText("2 STRENGTH","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,130,0)
				displayText("3 INTELLIGENCE","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,160,0)
				displayText("4 WISDOM","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,190,0)
				displayText("5 MANA","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,220,0)
				displayText(" ---- ","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,250,0)
				displayText("0 BACK","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,280,0)
				' displayText("-= ALPHA =-","",255,0,0,1,0,255,0,550,460,0)
			Case 3
				displayText("0 BACK","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,280,0)
				' displayText("-= ALPHA =-","",255,0,0,1,0,255,0,550,460,0)
			Case 4
				displayText("0 BACK","ichigo20",255,255,255,1,0,0,0,iGreyShadowX1Pos+20,280,0)
				' displayText("-= ALPHA =-","",255,0,0,1,0,255,0,550,460,0)
		End Select
		Flip(sync=1)
		While bIsEntryChosen=False And bQuitGame=False
			' ESC quits the game
			If KeyHit(KEY_ESCAPE) Then
				bQuitGame=True
			EndIf
			' IA chooses an action
			If bPlayer2Turn=True And iCombatMode=1 Then
				SeedRnd MilliSecs()
				Select iCurrentMenuLevel
					Case 1
						iPlayer2AttackNumber=Rand(1,3)
						If arCharacters.bIsSpecialActivated[iPlayer2SelectedCharacter]=False Then
							WriteStdout("IA chooses an action (iCurrentMenuLevel="+iCurrentMenuLevel+", iPlayer2AttackNumber="+iPlayer2AttackNumber+")"+Chr(13)+Chr(10))
						Else
							iPlayer2AttackNumber=1
						EndIf
					Case 2
						iPlayer2AttackNumber=Rand(1,5)
						WriteStdout("IA chooses an action (iCurrentMenuLevel="+iCurrentMenuLevel+", iPlayer2AttackNumber="+iPlayer2AttackNumber+")"+Chr(13)+Chr(10))
				End Select
				iChosenEntry=iPlayer2AttackNumber
				bIsEntryChosen=True
				Delay 800
			Else
				' Waiting for keys 0 to 9
				If KeyHit(KEY_0) Then
					iChosenEntry=0
					bIsEntryChosen=True
					WriteStdout("Player chooses an action : 0"+Chr(13)+Chr(10))
				EndIf
				If KeyHit(KEY_1) Then
					iChosenEntry=1
					bIsEntryChosen=True
					WriteStdout("Player chooses an action : 1"+Chr(13)+Chr(10))
				EndIf
				If KeyHit(KEY_2) Then
					iChosenEntry=2
					bIsEntryChosen=True
					WriteStdout("Player chooses an action : 2"+Chr(13)+Chr(10))
				EndIf
				If KeyHit(KEY_3) Then
					iChosenEntry=3
					bIsEntryChosen=True
					WriteStdout("Player chooses an action : 3"+Chr(13)+Chr(10))
				EndIf
				If KeyHit(KEY_4) Then
					iChosenEntry=4
					bIsEntryChosen=True
					WriteStdout("Player chooses an action : 4"+Chr(13)+Chr(10))
				EndIf
				If KeyHit(KEY_5) Then
					iChosenEntry=5
					bIsEntryChosen=True
					WriteStdout("Player chooses an action : 5"+Chr(13)+Chr(10))
				EndIf
				If KeyHit(KEY_6) Then
					iChosenEntry=6
					bIsEntryChosen=True
					WriteStdout("Player chooses an action : 6"+Chr(13)+Chr(10))
				EndIf
				If KeyHit(KEY_7) Then
					iChosenEntry=7
					bIsEntryChosen=True
					WriteStdout("Player chooses an action : 7"+Chr(13)+Chr(10))
				EndIf
				If KeyHit(KEY_8) Then
					iChosenEntry=8
					bIsEntryChosen=True
					WriteStdout("Player chooses an action : 8"+Chr(13)+Chr(10))
				EndIf
				If KeyHit(KEY_9) Then
					iChosenEntry=9
					bIsEntryChosen=True
					WriteStdout("Player chooses an action : 9"+Chr(13)+Chr(10))
				EndIf
			EndIf
			WriteStdout("=B====="+Chr(13)+Chr(10))
			WriteStdout("bIsEntryChosen="+bIsEntryChosen+Chr(13)+Chr(10))
			WriteStdout("bQuitGame="+bQuitGame+Chr(13)+Chr(10))
			WriteStdout("bPlayer1Turn="+bPlayer1Turn+Chr(13)+Chr(10))
			WriteStdout("bPlayer2Turn="+bPlayer2Turn+Chr(13)+Chr(10))
			WriteStdout("iCombatMode="+iCombatMode+Chr(13)+Chr(10))
			WriteStdout("iCurrentMenuLevel="+iCurrentMenuLevel+Chr(13)+Chr(10))
			WriteStdout("iPlayer2AttackNumber="+iPlayer2AttackNumber+Chr(13)+Chr(10))
			WriteStdout("iChosenEntry="+iChosenEntry+Chr(13)+Chr(10))
			WriteStdout("=E====="+Chr(13)+Chr(10))
		Wend
		Select iCurrentMenuLevel
			Case 1
				' Fight, Steal, Special, Item, Magic, Pass
				Select iChosenEntry
					Case 1
						' Fight
						iCurrentMenuLevel=2
					Case 2
						' Steal
						bIsCurrentActionAStealingAttempt=True
						If bPlayer1Turn=True Then
							iPlayer1AttackNumber=7
							iPlayer1RoundsCntr:+1
						Else
							iPlayer2AttackNumber=7
							iPlayer2RoundsCntr:+1
						EndIf
						iCurrentMenuLevel=1
						bIsActionChosen=True
					Case 3
						' Special feature (protect, reflect, heal, block, convert)
						If bPlayer1Turn=True Then
							iPlayer1AttackNumber=6
							arCharacters.bIsSpecialActivated[iPlayer1SelectedCharacter]=True
							iPlayer1RoundsCntr:+1
						Else
							iPlayer2AttackNumber=6
							arCharacters.bIsSpecialActivated[iPlayer2SelectedCharacter]=True
							iPlayer2RoundsCntr:+1
						EndIf
						bIsActionChosen=True
					Rem
					Case 4
						' Item
						iCurrentMenuLevel=3
					Case 5
						' Magic
						iCurrentMenuLevel=4
					End Rem
					Case 0
						' Pass
						iCurrentMenuLevel=1
						bIsActionChosen=True
				End Select
			Case 2
				' FIGHT : Cuteness, Strength, Intelligence, Wisdom, Mana, Back
				Select iChosenEntry
					Case 1
						' Cuteness
						If bPlayer1Turn=True Then
							iPlayer1AttackNumber=1
							iPlayer1RoundsCntr:+1
						Else
							iPlayer2AttackNumber=1
							iPlayer2RoundsCntr:+1
						EndIf
						bIsActionChosen=True
					Case 2
						' Strength
						If bPlayer1Turn=True Then
							iPlayer1AttackNumber=2
							iPlayer1RoundsCntr:+1
						Else
							iPlayer2AttackNumber=2
							iPlayer2RoundsCntr:+1
						EndIf
						bIsActionChosen=True
					Case 3
						' Intelligence
						If bPlayer1Turn=True Then
							iPlayer1AttackNumber=3
							iPlayer1RoundsCntr:+1
						Else
							iPlayer2AttackNumber=3
							iPlayer2RoundsCntr:+1
						EndIf
						bIsActionChosen=True
					Case 4
						' Wisdom
						If bPlayer1Turn=True Then
							iPlayer1AttackNumber=4
							iPlayer1RoundsCntr:+1
						Else
							iPlayer2AttackNumber=4
							iPlayer2RoundsCntr:+1
						EndIf
						bIsActionChosen=True
					Case 5
						' Mana
						If bPlayer1Turn=True Then
							iPlayer1AttackNumber=5
							iPlayer1RoundsCntr:+1
						Else
							iPlayer2AttackNumber=5
							iPlayer2RoundsCntr:+1
						EndIf
						bIsActionChosen=True
					Case 0
						' Back
						iCurrentMenuLevel=1
				End Select
			Rem
			Case 3
				' ITEM : List of items
				iCurrentMenuLevel=1
			Case 4
				' MAGIC : List
				iCurrentMenuLevel=1
			End Rem
		End Select
	Wend

	' Combat resolution
	Cls
	DrawImage(bmWarrior1,0,40)
	DrawImage(bmWarrior2,400,40)
	' Opponents names
	displayText(arCharacters.strName[iPlayer1SelectedCharacter]+"            "+arCharacters.strName[iPlayer2SelectedCharacter],"ichigo20",255,255,255,1,0,0,0,0,10,1)
	DrawImage(bmBottomBar,0,420)
	GrabImage(bmComputedPicture3,0,0)
	' Variables initialization
	bIsCombatActionOver=False
	bFlashScreenBackground=False
	iCombatStep=1
	iCombatStepInternalCntr=0
	strPlayerName=""
	strAttackType=""
	strIconType=""
	iDiceScore=0
	iBackgroundPic1PosX=0
	iBackgroundPic2PosX=1280
	SeedRnd MilliSecs()
	If bPlayer1Turn=True Then
		'Player 1
		strPlayerName="Player 1"
		If bIsCurrentActionAStealingAttempt=False Then
			Select iPlayer1AttackNumber
				Case 1
					strAttackType="CUTENESS"
					iDiceScore=Rand(1,arCharacters.iCuteness[iPlayer1SelectedCharacter])
				Case 2
					strAttackType="STRENGTH"
					iDiceScore=Rand(1,arCharacters.iStrength[iPlayer1SelectedCharacter])
				Case 3
					strAttackType="INTELLI."
					iDiceScore=Rand(1,arCharacters.iIntelligence[iPlayer1SelectedCharacter])
				Case 4
					strAttackType="WISDOM"
					iDiceScore=Rand(1,arCharacters.iWisdom[iPlayer1SelectedCharacter])
				Case 5
					strAttackType="MANA"
					iDiceScore=Rand(1,arCharacters.iMana[iPlayer1SelectedCharacter])
				Case 6
					strAttackType=arCharacters.strSpecial[iPlayer1SelectedCharacter]
					strIconType=arCharacters.strSpecial[iPlayer1SelectedCharacter]
			End Select
		Else
			' Stealing attempt
			iDiceScore=Rand(1,arCharacters.iIntelligence[iPlayer1SelectedCharacter])
		EndIf
	Else
		If bPlayer2Turn=True And iCombatMode=1 Then
			'CPU
			strPlayerName="CPU"
			If bIsCurrentActionAStealingAttempt=False Then
				Select iPlayer2AttackNumber
					Case 1
						strAttackType="CUTENESS"
						iDiceScore=Rand(1,arCharacters.iCuteness[iPlayer2SelectedCharacter])
					Case 2
						strAttackType="STRENGTH"
						iDiceScore=Rand(1,arCharacters.iStrength[iPlayer2SelectedCharacter])
					Case 3
						strAttackType="INTELLI."
						iDiceScore=Rand(1,arCharacters.iIntelligence[iPlayer2SelectedCharacter])
					Case 4
						strAttackType="WISDOM"
						iDiceScore=Rand(1,arCharacters.iWisdom[iPlayer2SelectedCharacter])
					Case 5
						strAttackType="MANA"
						iDiceScore=Rand(1,arCharacters.iMana[iPlayer2SelectedCharacter])
					Case 6
						strAttackType=arCharacters.strSpecial[iPlayer2SelectedCharacter]
						strIconType=arCharacters.strSpecial[iPlayer2SelectedCharacter]
				End Select
			Else
				' Stealing attempt
				iDiceScore=Rand(1,arCharacters.iIntelligence[iPlayer2SelectedCharacter])
			EndIf
		EndIf
		If bPlayer2Turn=True And iCombatMode=2 Then
			'Player 2
			strPlayerName="Player 2"
			If bIsCurrentActionAStealingAttempt=False Then
				Select iPlayer2AttackNumber
					Case 1
						strAttackType="CUTENESS"
						iDiceScore=Rand(1,arCharacters.iCuteness[iPlayer2SelectedCharacter])
					Case 2
						strAttackType="STRENGTH"
						iDiceScore=Rand(1,arCharacters.iStrength[iPlayer2SelectedCharacter])
					Case 3
						strAttackType="INTELLI."
						iDiceScore=Rand(1,arCharacters.iIntelligence[iPlayer2SelectedCharacter])
					Case 4
						strAttackType="WISDOM"
						iDiceScore=Rand(1,arCharacters.iWisdom[iPlayer2SelectedCharacter])
					Case 5
						strAttackType="MANA"
						iDiceScore=Rand(1,arCharacters.iMana[iPlayer2SelectedCharacter])
					Case 6
						strAttackType=arCharacters.strSpecial[iPlayer2SelectedCharacter]
						strIconType=arCharacters.strSpecial[iPlayer2SelectedCharacter]
				End Select
			Else
				' Stealing attempt
				iDiceScore=Rand(1,arCharacters.iIntelligence[iPlayer2SelectedCharacter])
			EndIf
		EndIf
	EndIf
	' Main combat loop
	progressiveMask(bmComputedPicture1, 0.0, 1.0, "up")
	While bIsCombatActionOver=False And bQuitGame = False
		Select iCombatStep
			Case 1
				iCombatStepInternalCntr:+1
				If iCombatStepInternalCntr>=50 Then
					iCombatStepInternalCntr=0
					iCombatStep=2
				EndIf
			Case 2
				' Action summary box appears on screen
				If iCombatStepInternalCntr=0 Then
					'If (((bPlayer1Turn=True) And (arCharacters.bIsSpecialActivated[iPlayer1SelectedCharacter]=False)) Or ((bPlayer2Turn=True) And (arCharacters.bIsSpecialActivated[iPlayer2SelectedCharacter]=False))) Then
					If iPlayer1AttackNumber<6 And iPlayer2AttackNumber<6 Then
						' Attack
						GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,180,88,264,0,4,99,80,"textbox","",0.8))
						GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,80,"text","Attack :",1.0))
						GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,210,88,264,0,4,99,80,"text",strAttackType,1.0))
						GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,270,88,264,0,4,99,80,"textbox","",0.8))
						GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,300,88,264,0,4,99,80,"text","Dice score :",1.0))
						GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,320,88,264,0,4,99,80,"text",iDiceScore,1.0))
					Else
						If bIsCurrentActionAStealingAttempt=False Then
							' Special
							GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,180,88,264,0,4,99,80,"textbox","",0.8))
							GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,80,"text","Special :",1.0))
							GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,210,88,264,0,4,99,80,"text",strAttackType,1.0))
							GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,270,88,264,0,4,99,80,"textbox","",0.8))
							GOList.AddLast(TGraphicalObject.CreateGO(1,255,255,255,288,282,64,64,0,4,99,80,"icon",strIconType,1.0))
						Else
							' Steal
							GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,180,88,264,0,4,99,80,"textbox","",0.8))
							GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,80,"text","Steal attempt !",1.0))
							GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,270,88,264,0,4,99,80,"textbox","",0.8))
							GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,300,88,264,0,4,99,80,"text","Dice score :",1.0))
							GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,320,88,264,0,4,99,80,"text",iDiceScore,1.0))
						EndIf
					EndIf
				EndIf
				iCombatStepInternalCntr:+1
				If iCombatStepInternalCntr>=80 Then
					iCombatStepInternalCntr=0
					iCombatStep=3
				EndIf
			Case 3
				' Screen flash : Background
				bFlashScreenBackground=True
				iCombatStepInternalCntr:+1
				If iCombatStepInternalCntr>=26 Then
					bFlashScreenBackground=False
					iCombatStepInternalCntr=0
					iCombatStep=4
				EndIf
			Case 4
				If iCombatStepInternalCntr=0 Then
					If bIsCurrentActionAStealingAttempt=False And iPlayer1AttackNumber<6 And iPlayer2AttackNumber<6 Then
						' Damages are shown
						' Lifepoints counter update
						If bPlayer1Turn=True Then
							arCharacters.iLifePoints[iPlayer2SelectedCharacter]=arCharacters.iLifePoints[iPlayer2SelectedCharacter]-iDiceScore
							GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,510,240,0,0,0,1,99,60,"scrolltext_up","-"+iDiceScore,1.0))
						Else
							If bPlayer2Turn=True Then
								arCharacters.iLifePoints[iPlayer1SelectedCharacter]=arCharacters.iLifePoints[iPlayer1SelectedCharacter]-iDiceScore
								GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,90,240,0,0,0,1,99,60,"scrolltext_up","-"+iDiceScore,1.0))
							EndIf
						EndIf
					Else
						If bIsCurrentActionAStealingAttempt=True Then
							' Steal
							If bPlayer1Turn=True Then
								' Player 1 tries to steal Player 2 bonus object
								If iDiceScore>arCharacters.iIntelligence[iPlayer2SelectedCharacter] Then
									bIsStealAttemptSuccessful=True
								Else
									bIsStealAttemptSuccessful=False
								EndIf
							Else
								If bPlayer2Turn=True Then
									' Player 2 tries to steal Player 1 bonus object
									If iDiceScore>arCharacters.iIntelligence[iPlayer1SelectedCharacter] Then
										bIsStealAttemptSuccessful=True
									Else
										bIsStealAttemptSuccessful=False
									EndIf
								EndIf
							EndIf
							GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,180,88,264,0,4,99,80,"textbox","",0.8))
							If bIsStealAttemptSuccessful=True Then
								GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,80,"text","Steal successful !",1.0))
							Else
								GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,80,"text","Steal fails...",1.0))
							EndIf
						EndIf
					EndIf
				EndIf
				iCombatStepInternalCntr:+1
				If iCombatStepInternalCntr>=80 Then
					iCombatStepInternalCntr=0
					iCombatStep=5
				EndIf
			Case 5
				' Current action is not a steal attempt or a special feature activation
				If bIsCurrentActionAStealingAttempt=False And iPlayer1AttackNumber<6 And iPlayer2AttackNumber<6 Then
					If iCombatStepInternalCntr=0 And bPlayer1Turn=True And arCharacters.bIsSpecialActivated[iPlayer2SelectedCharacter]=True Then
						GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,180,88,264,0,4,99,70,"textbox","",0.8))
						Select arCharacters.strSpecial[iPlayer2SelectedCharacter]
							Case "Heal"
								iSpecialScore=Rand(1,4)
								GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,70,"text","+ Healing +",1.0))
								GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,510,240,0,0,0,1,99,60,"scrolltext_up","+"+iSpecialScore,1.0))
								arCharacters.iLifePoints[iPlayer2SelectedCharacter]:+iSpecialScore
							Case "Protect"
								iSpecialScore=Rand(1,10)
								If iSpecialScore>6 Then
									iSpecialScore=Rand(1,6)
								Else
									iSpecialScore=0
								EndIf
								GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,70,"text","Protection",1.0))
								GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,510,240,0,0,0,1,99,60,"scrolltext_up","+"+iSpecialScore,1.0))
								arCharacters.iLifePoints[iPlayer2SelectedCharacter]:+iSpecialScore
							Case "Convert"
								iSpecialScore=Rand(1,iDiceScore)
								GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,70,"text","Converting",1.0))
								GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,510,240,0,0,0,1,99,60,"scrolltext_up","+"+iSpecialScore,1.0))
								arCharacters.iLifePoints[iPlayer2SelectedCharacter]:+iSpecialScore
							Case "Reflect"
								iSpecialScore=Rand(1,iDiceScore)
								GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,70,"text","Reflecting",1.0))
								GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,90,240,0,0,0,1,99,60,"scrolltext_up","-"+iSpecialScore,1.0))
								arCharacters.iLifePoints[iPlayer1SelectedCharacter]:-iSpecialScore
							Case "Block"
								iSpecialScore=Rand(1,4)
								If iSpecialScore<3 Then
									iSpecialScore=iDiceScore
								Else
									iSpecialScore=0
								EndIf
								GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,70,"text","|| Blocking ||",1.0))
								GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,510,240,0,0,0,1,99,60,"scrolltext_up","+"+iSpecialScore,1.0))
								arCharacters.iLifePoints[iPlayer2SelectedCharacter]:+iSpecialScore
						End Select
					Else
						If iCombatStepInternalCntr=0 And bPlayer2Turn=True And arCharacters.bIsSpecialActivated[iPlayer1SelectedCharacter]=True Then
							GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,180,88,264,0,4,99,70,"textbox","",0.8))
							Select arCharacters.strSpecial[iPlayer1SelectedCharacter]
								Case "Heal"
									iSpecialScore=Rand(1,4)
									GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,70,"text","+ Healing +",1.0))
									GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,90,240,0,0,0,1,99,60,"scrolltext_up","+"+iSpecialScore,1.0))
									arCharacters.iLifePoints[iPlayer1SelectedCharacter]:+iSpecialScore
								Case "Protect"
									iSpecialScore=Rand(1,10)
									If iSpecialScore>6 Then
										iSpecialScore=Rand(1,6)
									Else
										iSpecialScore=0
									EndIf
									GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,70,"text","Protection",1.0))
									GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,90,240,0,0,0,1,99,60,"scrolltext_up","+"+iSpecialScore,1.0))
									arCharacters.iLifePoints[iPlayer1SelectedCharacter]:+iSpecialScore
								Case "Convert"
									iSpecialScore=Rand(1,iDiceScore)
									GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,70,"text","Converting",1.0))
									GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,90,240,0,0,0,1,99,60,"scrolltext_up","+"+iSpecialScore,1.0))
									arCharacters.iLifePoints[iPlayer1SelectedCharacter]:+iSpecialScore
								Case "Reflect"
									iSpecialScore=Rand(1,iDiceScore)
									GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,70,"text","Reflecting",1.0))
									GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,510,240,0,0,0,1,99,60,"scrolltext_up","-"+iSpecialScore,1.0))
									arCharacters.iLifePoints[iPlayer2SelectedCharacter]:-iSpecialScore
								Case "Block"
									iSpecialScore=Rand(1,4)
									If iSpecialScore<3 Then
										iSpecialScore=iDiceScore
									Else
										iSpecialScore=0
									EndIf
									GOList.AddLast(TGraphicalObject.CreateGO(0,255,255,255,188,190,88,264,0,4,99,70,"text","|| Blocking ||",1.0))
									GOList.AddLast(TGraphicalObject.CreateGO(0,0,0,255,90,240,0,0,0,1,99,60,"scrolltext_up","+"+iSpecialScore,1.0))
									arCharacters.iLifePoints[iPlayer1SelectedCharacter]:+iSpecialScore
							End Select
						EndIf
					EndIf
					iCombatStepInternalCntr:+1
					If iCombatStepInternalCntr>=80 Then
						bIsCombatActionOver=True
						iCombatStepInternalCntr=0
						' iCombatStep=6
					EndIf
				Else
					bIsCombatActionOver=True
				EndIf
		End Select
		' Screen management
		Cls
		' Background scrolling refresh
		DrawImage(bmRougeJaune,iBackgroundPic1PosX,0)
		DrawImage(bmRougeJaune,iBackgroundPic2PosX,0)
		If bFlashScreenBackground=True Then
			If iCurrentScreenBackgroundColor=0 Then
				SetColor 0,0,255
				iCurrentScreenBackgroundColor=1
			Else
				SetColor 255,0,0
				iCurrentScreenBackgroundColor=0
			EndIf
			DrawRect 0,0,640,480
			SetColor 255,255,255
		Else
			' Background scrolling computation
			iBackgroundPic1PosX:-32
			If iBackgroundPic1PosX<-1280 Then
				iBackgroundPic1PosX=0
			EndIf
			iBackgroundPic2PosX:-32
			If iBackgroundPic2PosX<0 Then
				iBackgroundPic2PosX=1280
			EndIf
		EndIf
		DrawImage(bmWarrior1,0,40)
		DrawImage(bmWarrior2,400,40)
		' Opponents names
		displayText(arCharacters.strName[iPlayer1SelectedCharacter]+"            "+arCharacters.strName[iPlayer2SelectedCharacter],"ichigo20",255,255,255,1,0,0,0,0,10,1)
		If arCharacters.bIsSpecialActivated[iPlayer1SelectedCharacter]=True Then
			Select arCharacters.strSpecial[iPlayer1SelectedCharacter]
				Case "Heal"
					DrawImage(bmIconHeal,20,350)
				Case "Protect"
					DrawImage(bmIconProtect,20,350)
				Case "Convert"
					DrawImage(bmIconConvert,20,350)
				Case "Reflect"
					DrawImage(bmIconReflect,20,350)
				Case "Block"
					DrawImage(bmIconBlock,20,350)
			End Select
		EndIf
		If arCharacters.bIsSpecialActivated[iPlayer2SelectedCharacter]=True Then
			Select arCharacters.strSpecial[iPlayer2SelectedCharacter]
				Case "Heal"
					DrawImage(bmIconHeal,556,350)
				Case "Protect"
					DrawImage(bmIconProtect,556,350)
				Case "Convert"
					DrawImage(bmIconConvert,556,350)
				Case "Reflect"
					DrawImage(bmIconReflect,556,350)
				Case "Block"
					DrawImage(bmIconBlock,556,350)
			End Select
		EndIf
		DrawImage(bmBottomBar,0,420)
		' DrawImage(bmComputedPicture3,0,0)
		displayText(arCharacters.iLifePoints[iPlayer1SelectedCharacter],"ichigo20",0,0,0,0,0,0,0,10,440,0)
		displayText(arCharacters.iLifePoints[iPlayer2SelectedCharacter],"ichigo20",0,0,0,0,0,0,0,600,440,0)
		' displayText("-= ALPHA =-","",255,0,0,1,0,255,0,550,460,0)
		' TextBoxes update
		For CurrentGO=EachIn GOList
			SetAlpha CurrentGO.fAlpha
			If CurrentGO.strType="textbox" Then
				DrawImage(bmTextBox,CurrentGO.iPosX,CurrentGO.iPosY)
			Else
				If CurrentGO.strType="text" Then
					displayText(CurrentGO.strName,"ichigo20",255,0,0,0,0,0,0,10,CurrentGO.iPosY,1)
				Else
					If CurrentGO.strType="icon" Then
						Select strIconType
							Case "Heal"
								DrawImage(bmIconHeal,CurrentGO.iPosX,CurrentGO.iPosY)
							Case "Protect"
								DrawImage(bmIconProtect,CurrentGO.iPosX,CurrentGO.iPosY)
							Case "Convert"
								DrawImage(bmIconConvert,CurrentGO.iPosX,CurrentGO.iPosY)
							Case "Reflect"
								DrawImage(bmIconReflect,CurrentGO.iPosX,CurrentGO.iPosY)
							Case "Block"
								DrawImage(bmIconBlock,CurrentGO.iPosX,CurrentGO.iPosY)
						End Select
					Else
						If CurrentGO.strType="scrolltext_up" Then
							CurrentGO.iPosY:-CurrentGO.iSpeed
							CurrentGO.fAlpha:-0.01
							SetAlpha CurrentGO.fAlpha
							displayText(CurrentGO.strName,"ichigo40",CurrentGO.iColorR,CurrentGO.iColorG,CurrentGO.iColorB,1,255,255,255,CurrentGO.iPosX,CurrentGO.iPosY,0)
							SetAlpha 1.0
						EndIf
					EndIf
				EndIf
			EndIf
			SetAlpha 1.0
			CurrentGO.iCounter:-1
			If CurrentGO.iCounter=0 Then ListRemove(GOList,CurrentGO)
		Next
		Flip
		If KeyHit(KEY_ESC) Then
			bQuitGame=True
			bIsCombatActionOver=True
		EndIf
		' WaitTimer(tmrTimer50)
		WaitEvent
	Wend
	
	If bIsCurrentActionAStealingAttempt=True Then bIsCurrentActionAStealingAttempt=False
	
	' Change current player
	' and round number
	If bPlayer1Turn=True Then
		' From P1 to P2
		bPlayer1Turn=False
		bPlayer2Turn=True
	Else
		' From P2 to P1
		' Draw
		If arCharacters.iLifePoints[iPlayer1SelectedCharacter]<=0 And arCharacters.iLifePoints[iPlayer2SelectedCharacter]<=0 Then
			iCurrentRoundWinner=3
		Else
			' P2 wins
			If arCharacters.iLifePoints[iPlayer1SelectedCharacter]<=0 And arCharacters.iLifePoints[iPlayer2SelectedCharacter]>0 Then
				iCurrentRoundWinner=2
			Else
				' P1 wins
				If arCharacters.iLifePoints[iPlayer1SelectedCharacter]>0 And arCharacters.iLifePoints[iPlayer2SelectedCharacter]<=0 Then
					iCurrentRoundWinner=1
				EndIf
			EndIf
		EndIf
		If iCurrentRoundWinner<>0 Then
			Select iCurrentRound
				Case 0
					iRound1Winner=iCurrentRoundWinner
					iCurrentRoundWinner=0
				Case 1
					iRound2Winner=iCurrentRoundWinner
					iCurrentRoundWinner=0
				Case 2
					iRound3Winner=iCurrentRoundWinner
					iCurrentRoundWinner=0
			End Select
		EndIf
		If iRound1Winner>0 And iRound2Winner>0 And iRound3Winner>0 Then
			If iRound1Winner=1 Then iP1Victories:+1
			If iRound2Winner=1 Then iP1Victories:+1
			If iRound3Winner=1 Then iP1Victories:+1
			If iRound1Winner=2 Then iP2Victories:+1
			If iRound2Winner=2 Then iP2Victories:+1
			If iRound3Winner=2 Then iP2Victories:+1
			If iP1Victories<2 And iP2Victories<2 Then
				iWinner=3
			Else
				If iP1Victories<iP2Victories Then
					iWinner=2
				Else
					iWinner=1
				EndIf
			EndIf
		EndIf
		iCurrentRound:+1
		If iCurrentRound=3 Then iCurrentRound=0
		bPlayer2Turn=False
		bPlayer1Turn=True
	EndIf
	
	WriteStdout("    <combatManagement: OUT>    "+Chr(13)+Chr(10))
End Function

Function gameStop()
	WriteStdout("    <gameStop: IN>    "+Chr(13)+Chr(10))
	FlushKeys()
	GCCollect()
	ShowMouse()
	EndGraphics()
	WriteStdout("    <gameStop: OUT>    "+Chr(13)+Chr(10))
End Function


Function displayOpponents()
	WriteStdout("    <displayOpponents: IN>    "+Chr(13)+Chr(10))
	' Declaration et initialisation des variables locales
	' Les entiers
	' Cadres pour portraits des personnages - Arrivee par le bas
	Local iCompteurApparitionBmEcranCombatPortraitWindows:Int=480
	' Barre orange - Arrivee par la droite
	Local iCompteurApparitionBarreOrange:Int=640
	' Barres bleues - Arrivee par le haut
	Local iCompteurApparitionBarresBleues:Int=-480
	' Intitules des caracs des personnages - Arrivee par la gauche
	Local iCompteurApparitionIntitulesCaracs:Int=-640
	Local iCompteurApparitionPlayer1:Int=-240
	Local iCompteurApparitionPlayer2:Int=640
	' Les reels
	Local fCompteurZoomEcran:Float=2.0
	Local fCompteurDisparition:Float=1.0
	' Les images
	Local bmEcranCombatPortraitWindows:TImage=LoadImage("./pictures/ecran_combat_portrait_windows.png",FILTERED=-1)
	Local bmEcranCombatBarreOrange:TImage=LoadImage("./pictures/ecran_combat_barre_orange.png",FILTERED=-1)
	Local bmEcranCombatBarresBleues:TImage=LoadImage("./pictures/ecran_combat_barres_bleues.png",FILTERED=-1)
	Local bmEcranCombatIntitulesCaracs:TImage=LoadImage("./pictures/ecran_combat_intitules_caracs.png",FILTERED=-1)
	Local bmImageAZoomer:TImage
	Local bmEcranStatique5:TImage=LoadImage("./pictures/ecran_statique5.png",FILTERED=-1)
	Local bmEcranCombat:TImage=LoadImage("./pictures/ecran_combat.png",FILTERED=-1)
	Local bmComputedPicture1=CreateImage(640,480,DYNAMICIMAGE)
	Local bmComputedPicture2=CreateImage(640,480,DYNAMICIMAGE)
	
	' Creation de bmComputedPicture1
	Cls
	DrawImage(bmEcranCombat,0,0)
	displayText(">> "+arCharacters.strName[iPlayer1SelectedCharacter]+" ("+arCharacters.iLifePoints[iPlayer1SelectedCharacter]+")","ichigo20",255,255,255,1,0,0,0,20,270,0)
	displayText(">> "+arCharacters.strName[iPlayer2SelectedCharacter]+" ("+arCharacters.iLifePoints[iPlayer2SelectedCharacter]+")","ichigo20",255,255,255,1,0,0,0,390,270,0)
	GrabImage(bmComputedPicture1,0,0)
	
	' Creation de bmComputedPicture2
	Cls
	DrawImage(bmComputedPicture1,0,0)
	DrawImage(bmWarrior1,0,15)
	GrabImage(bmComputedPicture2,0,0)
	
	' Sequence d'affichage de l'ecran de gestion des combats
	progressiveMask(bmEcranStatique5, 1.0, 0.0, "down")
	' Apparition des cadres dans lesquels figureront les portraits des personnages
	' ainsi que des barres bleues situees au bas de l'ecran
	' Apparition de la barre orange et des caracs des personnages
	SetBlend ALPHABLEND
	While iCompteurApparitionBmEcranCombatPortraitWindows>0
		iCompteurApparitionBmEcranCombatPortraitWindows:-10
		iCompteurApparitionBarresBleues:+10
		iCompteurApparitionBarreOrange:-10
		iCompteurApparitionIntitulesCaracs:+10
		Cls
		DrawImage(bmEcranStatique5,0,0)
		SetAlpha 0.85
		DrawImage(bmEcranCombatBarreOrange,iCompteurApparitionBarreOrange,0)
		DrawImage(bmEcranCombatBarresBleues,0,iCompteurApparitionBarresBleues)
		SetAlpha 1.0
		DrawImage(bmEcranCombatPortraitWindows,0,iCompteurApparitionBmEcranCombatPortraitWindows)
		DrawImage(bmEcranCombatIntitulesCaracs,iCompteurApparitionIntitulesCaracs,0)
		Delay 5
		' displayText(GCMemAlloced(),"",255,255,255,1,0,0,0,560,460,0)
		Flip(sync=1)
	Wend
	
	' Choix et affichage des opposants
	' Joueur 1
	iCompteurApparitionPlayer1=-240
	While iCompteurApparitionPlayer1<0
		iCompteurApparitionPlayer1:+4
		Cls
		DrawImage(bmComputedPicture1,0,0)
		DrawImage(bmWarrior1,iCompteurApparitionPlayer1,15)
		Delay 5
		' displayText(GCMemAlloced(),"",255,255,255,1,0,0,0,560,460,0)
		Flip(sync=1)
	Wend
	' Joueur 2
	iCompteurApparitionPlayer2=640
	While iCompteurApparitionPlayer2>400
		iCompteurApparitionPlayer2:-4
		Cls
		DrawImage(bmComputedPicture2,0,0)
		DrawImage(bmWarrior2,iCompteurApparitionPlayer2,15)
		Delay 5
		' displayText(GCMemAlloced(),"",255,255,255,1,0,0,0,560,460,0)
		Flip(sync=1)
	Wend
		
	WriteStdout("    <displayOpponents: OUT>    "+Chr(13)+Chr(10))	
End Function

Function displayScores()
	WriteStdout("    <displayScores: IN>    "+Chr(13)+Chr(10))
	Local iCompteurDeadNeko:Int=0
	Local bmCombatScreen:TImage=LoadImage("./pictures/ecran_combat.png",FILTERED=-1)
	Local bmScoresScreen:TImage=LoadImage("./pictures/ecran_scores.png",FILTERED=-1)
	Local bmRedCross:TImage=LoadImage("./pictures/croix_rouge.png",FILTERED=-1)
	Local bmComputedPicture1=CreateImage(640,480,DYNAMICIMAGE)
	
	progressiveMask(bmCombatScreen, 0.0, 1.0, "up")
	
	Cls
	DrawImage(bmScoresScreen,0,0)
	' P1 and P2 victories
	If iRound1Winner=1 Then
		DrawImage(bmRedCross,254,137)
	Else
		If iRound1Winner=2 Then DrawImage(bmRedCross,254,323)
	EndIf
	If iRound2Winner=1 Then
		DrawImage(bmRedCross,318,137)
	Else
		If iRound2Winner=2 Then DrawImage(bmRedCross,318,323)
	EndIf
	If iRound3Winner=1 Then
		DrawImage(bmRedCross,382,137)
	Else
		If iRound3Winner=2 Then DrawImage(bmRedCross,382,323)
	EndIf
	' Number of rounds
	displayText("Rounds : "+iRoundsCntr,"chick60",255,255,255,1,0,0,0,999,418,1)
	GrabImage(bmComputedPicture1,0,0)
	
	progressiveMask(bmComputedPicture1, 1.0, 0.0, "down")
	DrawImage(bmComputedPicture1,0,0)
	
	Flip(sync=1)
	Delay 3000

	progressiveMask(bmComputedPicture1, 0.0, 1.0, "up")
	
	WriteStdout("    <displayScores: OUT>    "+Chr(13)+Chr(10))
End Function

Function displayWinner(iWinnerID:Int)
	WriteStdout("    <displayWinner: IN>    "+Chr(13)+Chr(10))
	Cls
	Select iWinnerID
		Case 1
			Local bmP1Wins:TImage=LoadImage("./pictures/ecran_player1wins.png",FILTERED=-1)
			progressiveMask(bmP1Wins, 1.0, 0.0, "down")
			DrawImage(bmP1Wins,0,0)
		Case 2
			If iCombatMode=1 Then
				Local bmCPUWins:TImage=LoadImage("./pictures/ecran_cpuwins.png",FILTERED=-1)
				progressiveMask(bmCPUWins, 1.0, 0.0, "down")
				DrawImage(bmCPUWins,0,0)
			Else
				Local bmP2Wins:TImage=LoadImage("./pictures/ecran_player2wins.png",FILTERED=-1)
				progressiveMask(bmP2Wins, 1.0, 0.0, "down")
				DrawImage(bmP2Wins,0,0)
			EndIf
		Case 3
			Local bmDraw:TImage=LoadImage("./pictures/ecran_draw.png",FILTERED=-1)
			progressiveMask(bmDraw, 1.0, 0.0, "down")
			DrawImage(bmDraw,0,0)
	End Select
	Flip
	Delay 3000
	WriteStdout("    <displayWinner: OUT>    "+Chr(13)+Chr(10))
End Function

Function modeDemo()
	WriteStdout("    <modeDemo: IN>    "+Chr(13)+Chr(10))
	' Declaration des variables locales
	' Les booleens
	Local bQuitterModeDemo:Byte=False
	' Les entiers
	Local iCompteurPersoAfficheModeDemo:Int=0
	Local iCompteurApparitionOmbre:Int=640
	Local iCompteurApparitionPerso:Int=400
	Local iCompteurApparitionElement1:Int=-479
	Local iCompteurApparitionElement2:Int=639
	Local iCompteurApparitionElement3:Int=479
	Local iCompteurApparitionElement4:Int=-639
	' Les reels
	Local iCompteurApparitionNomPerso:Float=0.0
	' Les images
	Local bmEcranDemo:TImage=LoadImage("./pictures/ecran_demo.png",FILTERED=-1)
	Local bmEcranDemoElement1:TImage=LoadImage("./pictures/ecran_demo_element1.png",FILTERED=-1)
	Local bmEcranDemoElement2:TImage=LoadImage("./pictures/ecran_demo_element2.png",FILTERED=-1)
	Local bmEcranDemoElement3:TImage=LoadImage("./pictures/ecran_demo_element3.png",FILTERED=-1)
	Local bmEcranDemoElement4:TImage=LoadImage("./pictures/ecran_demo_element4.png",FILTERED=-1)
	Local bmOmbrePersoAfficheModeDemo:TImage
	Local bmPersoAfficheModeDemo:TImage
	Local bmNomPersoAfficheModeDemo:TImage
	Local bmEcranStatique5:TImage=LoadImage("./pictures/ecran_statique5.png",FILTERED=-1)
	Local bmComputedPicture1=CreateImage(640,480,DYNAMICIMAGE)
	Local bmComputedPicture2=CreateImage(640,480,DYNAMICIMAGE)
	Local bmComputedPicture3=CreateImage(640,480,DYNAMICIMAGE)
	Local bmIconHeal:TImage=LoadImage("./pictures/icon_heal.png",FILTERED=-1)
	Local bmIconProtect:TImage=LoadImage("./pictures/icon_protect.png",FILTERED=-1)
	Local bmIconConvert:TImage=LoadImage("./pictures/icon_convert.png",FILTERED=-1)
	Local bmIconReflect:TImage=LoadImage("./pictures/icon_reflect.png",FILTERED=-1)
	Local bmIconBlock:TImage=LoadImage("./pictures/icon_block.png",FILTERED=-1)
	
	' Creation de bmComputedPicture1
	' Pour Element 2
	Cls
	DrawImage(bmEcranStatique5,0,0)
	DrawImage(bmEcranDemoElement1 , 0 , 0) 
	displayText("[ESC] = Return to main menu","",255,255,255,1,0,0,0,380,5,0)
	GrabImage(bmComputedPicture1,0,0)
	
	' Creation de bmComputedPicture2
	' Pour Element 3
	Cls
	DrawImage(bmEcranStatique5,0,0)
	DrawImage(bmEcranDemoElement1,0,0)
	DrawImage(bmEcranDemoElement2 , 0 , 0) 
	displayText("[ESC] = Return to main menu","",255,255,255,1,0,0,0,380,5,0)
	GrabImage(bmComputedPicture2,0,0)
	
	' Creation de bmComputedPicture3
	' Pour Element 4
	Cls
	DrawImage(bmEcranStatique5,0,0)
	DrawImage(bmEcranDemoElement1,0,0)
	DrawImage(bmEcranDemoElement2,0,0)
	DrawImage(bmEcranDemoElement3 , 0 , 0) 
	displayText("[ESC] = Return to main menu","",255,255,255,1,0,0,0,380,5,0)
	GrabImage(bmComputedPicture3,0,0)
	
	
	progressiveMask(bmEcranStatique5, 1.0, 0.0, "down")
	iDemoModeCntr=600
	bQuitterModeDemo=False
	While bQuitterModeDemo=False And Not KeyHit(KEY_ESCAPE)
		' Rien - Nothing - Nada - NOP
		' Chaque personnage apparait 3 secondes a l'ecran
		' 200 iterations d'un compteur a 5 millisecondes pour faire 1 seconde
		' Apparition de l'interface, puis du personnage
		If iDemoModeCntr=600 And bQuitterModeDemo=False Then
			iDemoModeCntr=0
			iCompteurPersoAfficheModeDemo:+1
			' Chargement des images
			If iCompteurPersoAfficheModeDemo=20 Then iCompteurPersoAfficheModeDemo=0
			bmOmbrePersoAfficheModeDemo=LoadImage("./pictures/character"+iCompteurPersoAfficheModeDemo+"_portrait_masque.png",FILTERED=-1)
			bmPersoAfficheModeDemo=LoadImage("./pictures/character"+iCompteurPersoAfficheModeDemo+"_portrait.png",FILTERED=-1)
			bmNomPersoAfficheModeDemo=LoadImage("./pictures/character"+iCompteurPersoAfficheModeDemo+"_name.png",FILTERED=-1)
			
			' Apparition de l'interface
			' Element 1
			While iCompteurApparitionElement1<0 And bQuitterModeDemo=False
				Cls
				DrawImage(bmEcranStatique5,0,0)
				DrawImage(bmEcranDemoElement1,0,iCompteurApparitionElement1)
				iCompteurApparitionElement1:+8
				Delay 5
				Flip(sync=1)
				If KeyHit(KEY_ESCAPE) Then bQuitterModeDemo=True
			Wend
			' Element 2
			While iCompteurApparitionElement2>=0 And bQuitterModeDemo=False
				Cls
				DrawImage(bmComputedPicture1,0,0)
				DrawImage(bmEcranDemoElement2,iCompteurApparitionElement2,0)
				iCompteurApparitionElement2:-8
				Delay 5
				Flip(sync=1)
				If KeyHit(KEY_ESCAPE) Then bQuitterModeDemo=True
			Wend
			' Element 3
			While iCompteurApparitionElement3>=0 And bQuitterModeDemo=False
				Cls
				DrawImage(bmComputedPicture2,0,0)
				DrawImage(bmEcranDemoElement3,0,iCompteurApparitionElement3)
				iCompteurApparitionElement3:-8
				Delay 5
				Flip(sync=1)
				If KeyHit(KEY_ESCAPE) Then bQuitterModeDemo=True
			Wend
			' Element 4
			While iCompteurApparitionElement4<0 And bQuitterModeDemo=False
				Cls
				DrawImage(bmComputedPicture3,0,0)
				DrawImage(bmEcranDemoElement4,iCompteurApparitionElement4,0)
				iCompteurApparitionElement4:+8
				Delay 5
				Flip(sync=1)
				If KeyHit(KEY_ESCAPE) Then bQuitterModeDemo=True
			Wend
			
			' Reinitialisation des variables d'affichage de l'interface
			iCompteurApparitionElement1=-479
			iCompteurApparitionElement2=639
			iCompteurApparitionElement3=479
			iCompteurApparitionElement4=-639
			
			' Apparition de l'ombre du personnage
			iCompteurApparitionOmbre=640
			While iCompteurApparitionOmbre>400 And bQuitterModeDemo=False
				iCompteurApparitionOmbre:-4
				Cls
				DrawImage(bmEcranDemo,0,0)
				DrawImage(bmOmbrePersoAfficheModeDemo,iCompteurApparitionOmbre,120)
				Delay 5
				Flip(sync=1)
				If KeyHit(KEY_ESCAPE) Then bQuitterModeDemo=True
			Wend
			' Apparition du personnage
			iCompteurApparitionPerso=400
			While iCompteurApparitionPerso<410 And bQuitterModeDemo=False
				iCompteurApparitionPerso:+1
				Cls
				DrawImage(bmEcranDemo,0,0)
				DrawImage(bmOmbrePersoAfficheModeDemo,iCompteurApparitionOmbre,120)
				DrawImage(bmPersoAfficheModeDemo,iCompteurApparitionPerso,120)
				Delay 5
				Flip(sync=1)
				If KeyHit(KEY_ESCAPE) Then bQuitterModeDemo=True
			Wend
			' Apparition du nom du personnage
			SetBlend ALPHABLEND
			iCompteurApparitionNomPerso=0.0
			While iCompteurApparitionNomPerso<1.0 And bQuitterModeDemo=False
				iCompteurApparitionNomPerso:+0.1
				Cls
				SetAlpha 1.0
				DrawImage(bmEcranDemo,0,0)
				DrawImage(bmOmbrePersoAfficheModeDemo,iCompteurApparitionOmbre,120)
				DrawImage(bmPersoAfficheModeDemo,iCompteurApparitionPerso,120)
				SetAlpha iCompteurApparitionNomPerso
				DrawImage(bmNomPersoAfficheModeDemo,320,380)
				displayText(arCharacters.iCuteness[iCompteurPersoAfficheModeDemo],"",255,255,255,1,0,0,0,222,215,0)
				displayText(arCharacters.iStrength[iCompteurPersoAfficheModeDemo],"",255,255,255,1,0,0,0,222,250,0)
				displayText(arCharacters.iIntelligence[iCompteurPersoAfficheModeDemo],"",255,255,255,1,0,0,0,222,285,0)
				displayText(arCharacters.iWisdom[iCompteurPersoAfficheModeDemo],"",255,255,255,1,0,0,0,222,320,0)
				displayText(arCharacters.iMana[iCompteurPersoAfficheModeDemo],"",255,255,255,1,0,0,0,222,355,0)
				Select arCharacters.strSpecial[iCompteurPersoAfficheModeDemo]
					Case "Heal"
						DrawImage(bmIconHeal,173,385)
					Case "Protect"
						DrawImage(bmIconProtect,173,385)
					Case "Convert"
						DrawImage(bmIconConvert,173,385)
					Case "Reflect"
						DrawImage(bmIconReflect,173,385)
					Case "Block"
						DrawImage(bmIconBlock,173,385)
				End Select
				Delay 5
				Flip(sync=1)
				If KeyHit(KEY_ESCAPE) Then bQuitterModeDemo=True
			Wend
		EndIf
		Delay 5
		iDemoModeCntr:+1
		If KeyHit(KEY_ESCAPE) Then bQuitterModeDemo=True
	Wend
	' Remise a zero du compteur servant a savoir quel personnage afficher
	' iCompteurPersoAfficheModeDemo=0
	' Remise a zero du compteur qui provoque le passage en mode demo
	iDemoModeCntr=0
	progressiveMask(bmEcranStatique5 , 0.0 , 1.0 , "up") 
	' Vidage du tampon clavier
	FlushKeys()
	GCCollect()
	WriteStdout("    <modeDemo: OUT>    "+Chr(13)+Chr(10))
End Function


Function teamCreation()
	WriteStdout("    <teamCreation: IN>    "+Chr(13)+Chr(10))
	Type TCharactersData
		Field iX:Int[20]
		Field iY:Int[20]
		Field iCharacterNbr:Int[20]
		Field strCharacterName:String[20]
	End Type
	Local arCharactersData:TCharactersData=New TCharactersData
	arCharactersData.iX=[292,362,432,502,572,292,362,432,502,572,292,362,432,502,572,292,362,432,502,572]
	arCharactersData.iY=[202,202,202,202,202,272,272,272,272,272,342,342,342,342,342,412,412,412,412,412]
	arCharactersData.iCharacterNbr=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
	arCharactersData.strCharacterName=["SYMETRIE","DDT","HECATE","LAVA","GIZMO","ACTIVIUS","BUBBLE","NEKALE","MEGA BURGER","RODOLPHE","AENAE","NETOILE","LAURA","FLAOUA","CROSS","EVIL FRAMBOISE","ULTRAMARINE","MO","SHAMAN","SHIBUYA"]
	Local arTeam1Faces:TImage[3]
	Local arTeam2Faces:TImage[3]
	Local arHiredCharacters:Int[20]
	Local arCOMReference[]=[0,14,18,7,3,17,1,2,4,13,9,15,11,12,16,10,5,8,19,6]
	Local bmTeamCreation:TImage = LoadImage("./pictures/ecran_constitution_equipe.png" , FILTERED = - 1)
	Local bmWhiteStringAndLeftPanel:TImage=LoadImage("./pictures/ecran_constitution_equipe-LEFT_PANE.png",FILTERED=-1)
	Local bmTeamCreationHelp:TImage = LoadImage("./pictures/ecran_constitution_equipe-HELP.png" , FILTERED = - 1) 
	Local bmTeamCreationHelpCPU:TImage=LoadImage("./pictures/ecran_constitution_equipe-HELPCPU.png",FILTERED=-1)
	Local bmBigYellowStarEyesClosed:TImage=LoadImage("./pictures/ecran_constitution_equipe-BIG_YELLOW_STAR-EYES_CLOSE.png",FILTERED=-1)
	Local bmBigYellowStarEyesOpen:TImage=LoadImage("./pictures/ecran_constitution_equipe-BIG_YELLOW_STAR-EYES_OPEN.png",FILTERED=-1)
	Local bmFace0:TImage=LoadImage("./pictures/character0_visage.png",FILTERED=-1)
	Local bmFace1:TImage=LoadImage("./pictures/character1_visage.png",FILTERED=-1)
	Local bmFace2:TImage=LoadImage("./pictures/character2_visage.png",FILTERED=-1)
	Local bmFace3:TImage=LoadImage("./pictures/character3_visage.png",FILTERED=-1)
	Local bmFace4:TImage=LoadImage("./pictures/character4_visage.png",FILTERED=-1)
	Local bmFace5:TImage=LoadImage("./pictures/character5_visage.png",FILTERED=-1)
	Local bmFace6:TImage=LoadImage("./pictures/character6_visage.png",FILTERED=-1)
	Local bmFace7:TImage=LoadImage("./pictures/character7_visage.png",FILTERED=-1)
	Local bmFace8:TImage=LoadImage("./pictures/character8_visage.png",FILTERED=-1)
	Local bmFace9:TImage=LoadImage("./pictures/character9_visage.png",FILTERED=-1)
	Local bmFace10:TImage=LoadImage("./pictures/character10_visage.png",FILTERED=-1)
	Local bmFace11:TImage=LoadImage("./pictures/character11_visage.png",FILTERED=-1)
	Local bmFace12:TImage=LoadImage("./pictures/character12_visage.png",FILTERED=-1)
	Local bmFace13:TImage=LoadImage("./pictures/character13_visage.png",FILTERED=-1)
	Local bmFace14:TImage=LoadImage("./pictures/character14_visage.png",FILTERED=-1)
	Local bmFace15:TImage=LoadImage("./pictures/character15_visage.png",FILTERED=-1)
	Local bmFace16:TImage=LoadImage("./pictures/character16_visage.png",FILTERED=-1)
	Local bmFace17:TImage=LoadImage("./pictures/character17_visage.png",FILTERED=-1)
	Local bmFace18:TImage=LoadImage("./pictures/character18_visage.png",FILTERED=-1)
	Local bmFace19:TImage=LoadImage("./pictures/character19_visage.png",FILTERED=-1)
	Local bmEmptyFace:TImage=LoadImage("./pictures/ecran_constitution_equipe-VISAGE_VIDE.png",FILTERED=-1)	
	Local bmP1Cursor:TImage=LoadImage("./pictures/viseur_selection_joueur1.png",FILTERED=-1)
	Local bmP2Cursor:TImage=LoadImage("./pictures/viseur_selection_joueur2.png",FILTERED=-1)
	Local bmCharacterName:TImage=LoadImage("./pictures/character0_name.png",FILTERED=-1)
	Local bmCharacterPicture:TImage=LoadImage("./pictures/character0_portrait.png",FILTERED=-1)
	Local bmUnavailableCharacterMark:TImage=LoadImage("./pictures/croix_rouge.png",FILTERED=-1)
	Local bmComputedPicture1=CreateImage(640,480,DYNAMICIMAGE)
	Local bIsTeamCreationOver:Byte=False
	Local bIsP1TeamComplete:Byte=False
	Local bIsP2TeamComplete:Byte=False
	Local bIsNewTeamCharacterFound:Byte=False
	Local bIsBYSBlinking:Byte=False
	Local iCurrentPlayer:Int=1
	Local iCntrFacesArrayInit:Int=0
	Local iCntrHiredCharacters:Int=0
	Local iCntrDisplayP1CharactersFaces:Int=0
	Local iCntrDisplayP2CharactersFaces:Int=0
	Local iTeam1LastEmptySlot:Int=0
	Local iTeam2LastEmptySlot:Int=0
	Local iBusyCPUCntr:Int=0
	Local iCurrentCharacter:Int=0
	Local iBYSEyelidYDirection:Int=6
	Local iBYSEyelidYPos:Int=191
	
	' Creation of bmComputedPicture1
	Cls
	DrawImage(bmTeamCreation,0,0)
	DrawImage(bmWhiteStringAndLeftPanel,0,0)
	DrawImage(bmFace0,294,204)
	DrawImage(bmFace1,364,204)
	DrawImage(bmFace2,434,204)
	DrawImage(bmFace3,504,204)
	DrawImage(bmFace4,574,204)
	DrawImage(bmFace5,294,274)
	DrawImage(bmFace6,364,274)
	DrawImage(bmFace7,434,274)
	DrawImage(bmFace8,504,274)
	DrawImage(bmFace9,574,274)
	DrawImage(bmFace10,294,344)
	DrawImage(bmFace11,364,344)
	DrawImage(bmFace12,434,344)
	DrawImage(bmFace13,504,344)
	DrawImage(bmFace14,574,344)
	DrawImage(bmFace15,294,414)
	DrawImage(bmFace16,364,414)
	DrawImage(bmFace17,434,414)
	DrawImage(bmFace18,504,414)
	DrawImage(bmFace19,574,414)
	GrabImage(bmComputedPicture1,0,0)
	
	' Random numbers generator : initialization
	SeedRnd MilliSecs()
	
	For iCntrFacesArrayInit=0 To 2 Step 1
		arTeam1Faces[iCntrFacesArrayInit]=bmEmptyFace
		arTeam2Faces[iCntrFacesArrayInit]=bmEmptyFace
	Next
	
	For iCntrHiredCharacters=0 To 19 Step 1
		arHiredCharacters[iCntrHiredCharacters]=0
	Next
	
	' Main loop
	While (bQuitGame=False) And (bIsTeamCreationOver=False)
		WriteStdout("    <teamCreation: main loop>    "+Chr(13)+Chr(10))
		Cls
		DrawImage(bmComputedPicture1,0,0)
		If KeyHit(KEY_ESCAPE) Then
			bQuitGame=True
		EndIf
		If (iCurrentPlayer=1) Or ((iCurrentPlayer=2) And (iCombatMode=2)) Then
			' Human player
			If (iCurrentPlayer=1 And iTeam1LastEmptySlot<3) Or (iCurrentPlayer=2 And bIsP2TeamComplete=False And iCombatMode=2) Then
				DrawImage(bmTeamCreationHelp,0,0)
			EndIf
			If KeyHit(KEY_UP) Then
				If iCursorPos>=5 Then
					iCursorPos:-5
				Else
					iCursorPos:+15
				EndIf
				bmCharacterName=LoadImage("./pictures/character"+iCursorPos+"_name.png",FILTERED=-1)
				bmCharacterPicture=LoadImage("./pictures/character"+iCursorPos+"_portrait.png",FILTERED=-1)
			Else
				If KeyHit(KEY_DOWN) Then
					If iCursorPos<=14 Then
						iCursorPos:+5
					Else
						iCursorPos:-15
					EndIf
					bmCharacterName=LoadImage("./pictures/character"+iCursorPos+"_name.png",FILTERED=-1)
					bmCharacterPicture=LoadImage("./pictures/character"+iCursorPos+"_portrait.png",FILTERED=-1)
				Else
					If KeyHit(KEY_LEFT) Then
						If ((iCursorPos>0) And (iCursorPos<5)) Or ((iCursorPos>5) And (iCursorPos<10)) Or ((iCursorPos>10) And (iCursorPos<15)) Or ((iCursorPos>15) And (iCursorPos<20)) Then
							iCursorPos:-1
						Else
							iCursorPos:+4
						EndIf
						bmCharacterName=LoadImage("./pictures/character"+iCursorPos+"_name.png",FILTERED=-1)
						bmCharacterPicture=LoadImage("./pictures/character"+iCursorPos+"_portrait.png",FILTERED=-1)
					Else
						If KeyHit(KEY_RIGHT) Then
							If ((iCursorPos>=0) And (iCursorPos<4)) Or ((iCursorPos>=5) And (iCursorPos<9)) Or ((iCursorPos>=10) And (iCursorPos<14)) Or ((iCursorPos>=15) And (iCursorPos<19)) Then
								iCursorPos:+1
							Else
								iCursorPos:-4
							EndIf
							bmCharacterName=LoadImage("./pictures/character"+iCursorPos+"_name.png",FILTERED=-1)
							bmCharacterPicture=LoadImage("./pictures/character"+iCursorPos+"_portrait.png",FILTERED=-1)
						Else
							If KeyHit(KEY_SPACE) Then
								' Unselect the last selected character
								If iCurrentPlayer=1 And iTeam1LastEmptySlot>0 And bIsP1TeamComplete=False Then
									iTeam1LastEmptySlot:-1
									arHiredCharacters[arPlayer1Team[iTeam1LastEmptySlot]]=0
									arTeam1Faces[iTeam1LastEmptySlot]=bmEmptyFace
									arPlayer1Team[iTeam1LastEmptySlot]=99
								EndIf
								If iCurrentPlayer=2 And iTeam2LastEmptySlot>0 And bIsP2TeamComplete=False Then
									iTeam2LastEmptySlot:-1
									arHiredCharacters[arPlayer2Team[iTeam2LastEmptySlot]]=0
									arTeam2Faces[iTeam2LastEmptySlot]=bmEmptyFace
									arPlayer2Team[iTeam2LastEmptySlot]=99
								EndIf
							Else
								If KeyHit(KEY_ENTER) Then
									' Add current character to team
									If iCurrentPlayer=1 And bIsP1TeamComplete=False Then
										If arHiredCharacters[iCursorPos]=0 And iTeam1LastEmptySlot<3 Then
											arHiredCharacters[iCursorPos]=1
											arTeam1Faces[iTeam1LastEmptySlot]=LoadImage("./pictures/character"+iCursorPos+"_visage.png",FILTERED=-1)
											arPlayer1Team[iTeam1LastEmptySlot]=iCursorPos
											iTeam1LastEmptySlot:+1
										EndIf
										If iTeam1LastEmptySlot=3 Then
											bIsP1TeamComplete=True
										EndIf
									EndIf
									If iCurrentPlayer=2 And bIsP2TeamComplete=False Then
										If arHiredCharacters[iCursorPos]=0 And iTeam2LastEmptySlot<3 Then
											If bIsP2TeamComplete=False Then
												arHiredCharacters[iCursorPos]=1
												arTeam2Faces[iTeam2LastEmptySlot]=LoadImage("./pictures/character"+iCursorPos+"_visage.png",FILTERED=-1)
												arPlayer2Team[iTeam2LastEmptySlot]=iCursorPos
												iTeam2LastEmptySlot:+1
											EndIf
										EndIf
										If iTeam2LastEmptySlot=3 Then
											bIsP2TeamComplete=True
										EndIf
									EndIf
								Else
									If KeyHit(KEY_Y) Then
										If iCurrentPlayer=1 And bIsP1TeamComplete=True Then
											iCurrentPlayer=2
										EndIf
										If iCurrentPlayer=2 And bIsP2TeamComplete=True Then
											bIsTeamCreationOver=True
										EndIf
									Else
										If KeyHit(KEY_N) Then
											If iCurrentPlayer=1 And bIsP1TeamComplete=True Then
												bIsP1TeamComplete=False
											EndIf
											If iCurrentPlayer=2 And bIsP2TeamComplete=True Then
												bIsP2TeamComplete=False
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			If (iCurrentPlayer=2) And (iCombatMode=1) Then
				' CPU
				If bIsP2TeamComplete=False Then
					DrawImage(bmTeamCreationHelpCPU,0,0)
					iBusyCPUCntr:+1
					If iBusyCPUCntr=50 Then
						iBusyCPUCntr=0
						While bIsNewTeamCharacterFound=False
							If arHiredCharacters[arCOMReference[iCurrentCharacter]]=0 Then
								bIsNewTeamCharacterFound=True
								arHiredCharacters[arCOMReference[iCurrentCharacter]]=1
								arPlayer2Team[iTeam2LastEmptySlot]=arCOMReference[iCurrentCharacter]
								iCursorPos=arCOMReference[iCurrentCharacter]
								bmCharacterName=LoadImage("./pictures/character"+iCursorPos+"_name.png",FILTERED=-1)
								bmCharacterPicture=LoadImage("./pictures/character"+iCursorPos+"_portrait.png",FILTERED=-1)
								arTeam2Faces[iTeam2LastEmptySlot]=LoadImage("./pictures/character"+iCursorPos+"_visage.png",FILTERED=-1)
								iTeam2LastEmptySlot:+1
								If iTeam2LastEmptySlot=3 Then bIsP2TeamComplete=True
							EndIf
							iCurrentCharacter:+1
						Wend
						bIsNewTeamCharacterFound=False
					EndIf
				Else
					iBusyCPUCntr:+1
					If iBusyCPUCntr=100 Then bIsTeamCreationOver=True
				EndIf
			EndIf
		EndIf
		
		If iCurrentPlayer=1 Then
			For iCntrDisplayP1CharactersFaces=0 To 2 Step 1
				DrawImage(arTeam1Faces[iCntrDisplayP1CharactersFaces],12,(55+(79*iCntrDisplayP1CharactersFaces)))
			Next
		Else
			For iCntrDisplayP2CharactersFaces=0 To 2 Step 1
				DrawImage(arTeam2Faces[iCntrDisplayP2CharactersFaces],12,(55+(79*iCntrDisplayP2CharactersFaces)))
			Next
		EndIf

		If arHiredCharacters[0]=1 Then DrawImage(bmUnavailableCharacterMark,303,209)
		If arHiredCharacters[1]=1 Then DrawImage(bmUnavailableCharacterMark,373,209)
		If arHiredCharacters[2]=1 Then DrawImage(bmUnavailableCharacterMark,443,209)
		If arHiredCharacters[3]=1 Then DrawImage(bmUnavailableCharacterMark,513,209)
		If arHiredCharacters[4]=1 Then DrawImage(bmUnavailableCharacterMark,583,209)
		If arHiredCharacters[5]=1 Then DrawImage(bmUnavailableCharacterMark,303,279)
		If arHiredCharacters[6]=1 Then DrawImage(bmUnavailableCharacterMark,373,279)
		If arHiredCharacters[7]=1 Then DrawImage(bmUnavailableCharacterMark,443,279)
		If arHiredCharacters[8]=1 Then DrawImage(bmUnavailableCharacterMark,513,279)
		If arHiredCharacters[9]=1 Then DrawImage(bmUnavailableCharacterMark,583,279)
		If arHiredCharacters[10]=1 Then DrawImage(bmUnavailableCharacterMark,303,349)
		If arHiredCharacters[11]=1 Then DrawImage(bmUnavailableCharacterMark,373,349)
		If arHiredCharacters[12]=1 Then DrawImage(bmUnavailableCharacterMark,443,349)
		If arHiredCharacters[13]=1 Then DrawImage(bmUnavailableCharacterMark,513,349)
		If arHiredCharacters[14]=1 Then DrawImage(bmUnavailableCharacterMark,583,349)
		If arHiredCharacters[15]=1 Then DrawImage(bmUnavailableCharacterMark,303,419)
		If arHiredCharacters[16]=1 Then DrawImage(bmUnavailableCharacterMark,373,419)
		If arHiredCharacters[17]=1 Then DrawImage(bmUnavailableCharacterMark,443,419)
		If arHiredCharacters[18]=1 Then DrawImage(bmUnavailableCharacterMark,513,419)
		If arHiredCharacters[19]=1 Then DrawImage(bmUnavailableCharacterMark,583,419)

		If iCurrentPlayer=1 Then
			DrawImage(bmP1Cursor,arCharactersData.iX[iCursorPos],arCharactersData.iY[iCursorPos])
			displayText("Player 1","chick60",255,255,255,1,0,0,0,999,5,1)
		Else
			DrawImage(bmP2Cursor,arCharactersData.iX[iCursorPos],arCharactersData.iY[iCursorPos])
			If iCombatMode=1 Then
				displayText("Computer","chick60",255,255,255,1,0,0,0,999,5,1)
			Else
				displayText("Player 2","chick60",255,255,255,1,0,0,0,999,5,1)
			EndIf
		EndIf
		
		DrawImage(bmCharacterName,306,90)
		DrawImage(bmCharacterPicture,75,40)
		
		If (iCurrentPlayer=1 And bIsP1TeamComplete=True) Or (iCurrentPlayer=2 And bIsP2TeamComplete=True) Then
			SetAlpha 0.5
			SetColor 0,0,0
			DrawRect 103,0,537,480
			SetColor 255,255,255
			SetAlpha 1.0
			DrawImage(bmBigYellowStarEyesOpen,0,0)
			If bIsBYSBlinking=False Then
				If Rand(100)>98 Then bIsBYSBlinking=True
			EndIf
			If bIsBYSBlinking=True Then
				SetColor 255,204,0
				DrawRect 327,191,80,(iBYSEyelidYPos-191)
				SetColor 255,255,255
				iBYSEyelidYPos=iBYSEyelidYPos+iBYSEyelidYDirection
				If iBYSEyelidYPos>=248 Then
					iBYSEyelidYDirection=-6
				EndIf
				If iBYSEyelidYPos<=191 Then
					iBYSEyelidYDirection=6
					bIsBYSBlinking=False
				EndIf
			EndIf
		EndIf
		
		Flip(sync=1)
		Delay 5
		' WaitEvent
	Wend
	FlushKeys()
	GCCollect()
	WriteStdout("    <teamCreation: OUT>    "+Chr(13)+Chr(10))
End Function

Function displayText(strTextToDisplay:String, strFont:String, iR:Int, iG:Int, iB:Int, iShadow:Int, iRShadow:Int, iGShadow:Int, iBShadow:Int, iPosX:Int, iPosY:Int, iAlignMode:Int)
	'Reminder : black=0 / white=255
	' iAlignMode : 0=disabled -- 1=X axis centered -- 2=Y axis centered -- 3=Both X and Y axis centered
	'If iShadow is set to 0, there will be no shadow behind the text
	' Variables declaration and initialization
	' Integer
	Local iOldRed:Int=0
	Local iOldGreen:Int=0
	Local iOldBlue:Int=0
	Local iRecomputedPosX:Int=iPosX
	Local iRecomputedPosY:Int=iPosY
	' Fonts
	Local fntChick60:TImagefont=LoadImageFont("./fonts/chick.ttf",60)
	Local fntChick80:TImagefont=LoadImageFont("./fonts/chick.ttf",80) 
	Local fntIchigo20:TImagefont=LoadImageFont("./fonts/ichig_reg.ttf",20)
	Local fntIchigo40:TImagefont=LoadImageFont("./fonts/ichig_reg.ttf",40)
	
	Select strFont
		Case ""
			SetImageFont(Null)
		Case "chick60"
			SetImageFont(fntChick60)
		Case "chick80"
			SetImageFont(fntChick80) 
		Case "ichigo20"
			SetImageFont(fntIchigo20)
		Case "ichigo40"
			SetImageFont(fntIchigo40)
		Default
			SetImageFont(Null)
	End Select
	
	Select iAlignMode
		Case 0
			' Disabled
		Case 1
			' X axis centered
			iRecomputedPosX=((GraphicsWidth()/2)-(TextWidth(strTextToDisplay)/2))
		Case 2
			' Y axis centered
			iRecomputedPosY=((GraphicsHeight()/2)-(TextHeight(strTextToDisplay)/2))
		Case 3
			' X and Y axis centered
			' X axis centered
			iRecomputedPosX=((GraphicsWidth()/2)-(TextWidth(strTextToDisplay)/2))
			' Y axis centered
			iRecomputedPosY=((GraphicsHeight()/2)-(TextHeight(strTextToDisplay)/2))
		Default
	End Select
	
	' Original color parameters are backuped
	GetColor(iOldRed,iOldGreen,iOldBlue)
	If iShadow=1 Then
		' Shadow
		SetColor iRShadow, iGShadow, iBShadow
		DrawText(strTextToDisplay,iRecomputedPosX+1,iRecomputedPosY+1)
	EndIf
	SetColor iR,iG,iB
	DrawText(strTextToDisplay,iRecomputedPosX,iRecomputedPosY)
	' Original color parameters are restaured
	SetColor(iOldRed,iOldGreen,iOldBlue)
End Function

Function gameInit()
	' Variables initialization
	' Integers
	x=GraphicsWidth () / 2
	y=GraphicsHeight () / 2
	iCombatMode=0
	iPlayer1SelectedCharacter=0
	iPlayer2SelectedCharacter=0
	iRoundsCntr=0
	iCurrentRound=0
	iDemoModeCntr=0
	iRound1Winner=0
	iRound2Winner=0
	iRound3Winner=0
	iWinner=0
	' Strings
	' Arrays
	arCharacters.strName=["Symetrie","DDT","Hecate","Lava","Gizmo","Activius","Bubble","Nekale","Mega Burger","Rodolphe","Aenae","Netoile","Laura","Flaoua","Cross","Evil Framboise","Ultramarine","Mo","Shaman","Shibuya"]
	arCharacters.iCuteness=[10,9,6,7,5,2,1,5,2,8,4,10,5,8,6,7,7,7,4,3]
	arCharacters.iStrength=[6,5,7,8,4,9,1,6,7,2,6,5,7,3,8,7,7,7,8,4]
	arCharacters.iIntelligence=[5,4,7,7,8,6,2,10,5,5,6,3,6,4,8,7,7,8,10,2]
	arCharacters.iWisdom=[10,8,5,5,10,3,1,9,1,10,7,4,6,10,10,5,4,5,7,4]
	arCharacters.iMana=[8,7,8,9,6,4,10,8,7,7,3,6,4,8,7,3,2,8,10,6]
	arCharacters.strSpecial=["Heal","Heal","Protect","Convert","Protect","Protect","Reflect","Protect","Block","Heal","Protect","Protect","Block","Heal","Protect","Heal","Heal","Reflect","Convert","Reflect"]
	arCharacters.bIsSpecialActivated=[False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False]
	' arCharacters.iLifePoints=[40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40]
	arCharacters.iLifePoints=[20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20]
	arPlayer1Score=[9,9,9,9,9,9,9,9,9,9,9,9]
	arPlayer2Score=[9,9,9,9,9,9,9,9,9,9,9,9]
	arPlayer1Team=[99,99,99]
	arPlayer2Team=[99,99,99]
	' Booleans
	' 0=true // 1=false
	bPlayer1Turn=True
	bPlayer2Turn=False
	bQuitGame=False
	FlushKeys()
	GCCollect()
End Function

Function cheatCodeActivation(strCheat:String)
	WriteStdout("    <cheatCodeActivation: IN>    "+Chr(13)+Chr(10))
	Local bmBackground:TImage=CreateImage(640,480,DYNAMICIMAGE)
	Local bmCloudEyesOpen:TImage=LoadImage("./pictures/cloud-in_love.png",FILTERED=-1)
	Local bmCloudEyesClosed:TImage=LoadImage("./pictures/cloud-in_love-small_eyes.png",FILTERED=-1)
	Local iFrameCntr:Int=0
	Local iFrameRef:Int=0
	Local bAreEyesClosed:Byte=False
	SetAlpha 0.5
	SetColor 0,0,0
	DrawRect 0,0,640,480
	SetColor 255,255,255
	SetAlpha 1.0
	SetAlpha 0.5
	SetColor 0,0,0
	DrawRect 0,20,640,68
	SetColor 255,255,255
	SetAlpha 1.0
	Select strCheat
		Case "LOBELYA"
			displayText(".: LOBELYA :.","chick60",255,255,255,1,0,0,0,999,20,1)
	End Select
	GrabImage(bmBackground,0,0)
	While iFrameCntr<250
		iFrameCntr:+1
		Cls
		DrawImage(bmBackground,0,0)
		If Rand(1,200)>199 And bAreEyesClosed=False Then
			bAreEyesClosed=True
			iFrameRef=iFrameCntr
		EndIf
		If bAreEyesClosed=False Then
			DrawImage(bmCloudEyesOpen,0,0)
		Else
			DrawImage(bmCloudEyesClosed,0,0)
			If iFrameCntr=iFrameRef+4 Then bAreEyesClosed=False
		EndIf
		Flip
		Delay 5
	Wend
	FlushKeys()
	GCCollect()
	WriteStdout("    <cheatCodeActivation: OUT>    "+Chr(13)+Chr(10))
End Function


