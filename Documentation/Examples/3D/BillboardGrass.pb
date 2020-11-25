;
; ------------------------------------------------------------
;
;   PureBasic - Billboard
;
;    (c) Fantaisie Software
;
; ------------------------------------------------------------
;

#CameraSpeed = 2

IncludeFile #PB_Compiler_Home + "examples/3d/Screen3DRequester.pb"

Define.f KeyX, KeyY, MouseX, MouseY

If InitEngine3D()
  
  InitSprite()
  InitKeyboard()
  InitMouse()
  
  If Screen3DRequester()
    
    Add3DArchive(#PB_Compiler_Home + "examples/3d/Data/Textures", #PB_3DArchive_FileSystem)
    Add3DArchive(#PB_Compiler_Home + "examples/3d/Data/Models", #PB_3DArchive_FileSystem)
    Add3DArchive(#PB_Compiler_Home + "examples/3d/Data/Scripts", #PB_3DArchive_FileSystem)
    Add3DArchive(#PB_Compiler_Home + "examples/3d/Data/Packs/skybox.zip", #PB_3DArchive_Zip)
    Parse3DScripts()
    
    ; First create materials
    ;
    
    GrassMaterial = CreateMaterial(#PB_Any, TextureID(LoadTexture(#PB_Any,"grass1.png")))
    MaterialBlendingMode(GrassMaterial, #PB_Material_AlphaBlend)
    DirtMaterial = CreateMaterial(#PB_Any, TextureID(LoadTexture(#PB_Any,"Dirt.jpg")))
    
    
    ; Then create the billboard group and use the previous material
    ;
    ;-Billboard
    
    Billboard = CreateBillboardGroup(#PB_Any, MaterialID(GrassMaterial), 96, 96, 0, 0, 0, -1, 1)
    BillboardGroupCommonDirection(Billboard, 0, 1, 0)
        
    For i = 0 To 600
      AddBillboard(Billboard, Random(2000)-1000, Random(18) + 30, Random(2000) - 1000)
    Next i

    ; create ground
    
    MeshPlane = CreatePlane(#PB_Any, 2000, 2000, 40, 40, 4, 4)
    CreateEntity(#PB_Any, MeshID(MeshPlane), MaterialID(DirtMaterial))
    
    ; Add house
    MeshHouse = LoadMesh(#PB_Any, "tudorhouse.mesh")
    House = CreateEntity(#PB_Any, MeshID(MeshHouse), #PB_Material_None, 0, 280, 0)
    ScaleEntity(House, 0.5, 0.5, 0.5)
    
    ; SkyBox
    SkyBox("stevecube.jpg")
    
    ; create camera
    Camera = CreateCamera(#PB_Any, 0, 0, 100, 100)
    MoveCamera(Camera, 200, 400, 900, #PB_Absolute)
    CameraLookAt(Camera, 0, 100, 0)
    
    Repeat
      Screen3DEvents()
      
      If ExamineMouse()
        MouseX = -MouseDeltaX() * #CameraSpeed * 0.05
        MouseY = -MouseDeltaY() * #CameraSpeed * 0.05
      EndIf
      
      If ExamineKeyboard()
        
        If KeyboardPushed(#PB_Key_Left)
          KeyX = -#CameraSpeed 
        ElseIf KeyboardPushed(#PB_Key_Right)
          KeyX = #CameraSpeed 
        Else
          KeyX = 0
        EndIf
        
        If KeyboardPushed(#PB_Key_Up)
          KeyY = -#CameraSpeed 
        ElseIf KeyboardPushed(#PB_Key_Down)
          KeyY = #CameraSpeed 
        Else
          KeyY = 0
        EndIf
        
      EndIf
      
      RotateCamera(Camera, MouseY, MouseX, 0, #PB_Relative)
      MoveCamera  (Camera, KeyX, 0, KeyY)
      
      RenderWorld()
      Screen3DStats()
      FlipBuffers()
    Until KeyboardPushed(#PB_Key_Escape) Or Quit = 1
  EndIf
  
Else
  MessageRequester("Error", "The 3D Engine can't be initialized",0)
EndIf

End