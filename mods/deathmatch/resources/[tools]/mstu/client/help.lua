LuaQ     @           /      @@ d   	@    d@  	@   d  	@    dÀ  	@   d  	@    d@ 	@   d 	@    dÀ 	@   d  	@    d@ 	@   d 	@    dÀ 	@   d  	@    d@ 	@   d 	@         mstu    gui 
   startHelp    open_text_tut 	   sub_help    help    onBrowserCreate    onHelpRender    browserOnClick    onCursorMove    onMyMouseDoubleClick    changeBrowserSizeState 
   get_link1 
   get_link2 
   get_link3    get_full_tutorial    get_donatte           :     8   E   IÀJ    Å  Ï@Á ÁAÍ  AAE NÂOAÂAE NÂ BAB¢@ Ê  Á AÁ  Å â@ b@ 	@	@C	ÀCE  @ Å   ÁD\@ E    Å   AE\@ E   ÅÀ   F\@ E  @ Å   F\@         mstu    tut_id    QBTPbJoLwf0    browser_size    sx        @   sy ìQ¸ëÁ?      Ð?¦Ä °rü?      à?           description g  #ffffff
    [00:00 - 00:50] #AAAAAA Tool show off #ffffff
    [01:00 - 01:12] #AAAAAA Basic controls #ffffff
    [01:05 - 03:33] #AAAAAA Selection options #ffffff
    [03:34 - 05:00] #AAAAAA Filter #ffffff
    [05:01 - 05:20] #AAAAAA Large group selection #ffffff
    [05:30 - 06:04] #AAAAAA Pivot #ffffff
    [06:05 - 07:40] #AAAAAA Duplicate #ffffff
    [07:41 - 10:24] #AAAAAA Element library #ffffff
    [10:25 - 16:00] #AAAAAA Cover elements #ffffff
    [16:01 - 18:24] #AAAAAA Element properties #ffffff
    [18:25 - 20:15] #AAAAAA Settings #999999

    (press twice on the video
    to watch on full screen)    description2 ·      â¢   You canât delete groups in library created by someone else (only manually in xml)
    â¢   You should save map before creating large groups
    â¢   You should be aware of slow drawing distance when you use cover or duplicate tools
    â¢   Filter works for all selection tools except wand
    â¢   In case you select various elements, cover tool detects dominating model to be covered
    â¢   In case you select various element types and use properties, tool detects dominating element type
    â¢   When you start selecting you can switch between 4 selection modes and group wonât get destroyed
    â¢   If you want to select only few elements itâs faster to hold G, select elements and release G 
        so group will be created immediately
    â¢   cover default settings and overall tool settings are stored in following location - 
        MTA/server/mods/deathmatch/databases/global/mstu_database.db 
        so if you donât want to lose them after reinstalling MTA, make a backup
    â¢   Library and cover compositions are stored in toolâs folder in xml files. You can edit them manually and for example 
        add someoneâs library. I encourage you to make such libraries and share them with others by sending library.xml or cover.xml 
        files. In case you donât know how to join 2 libraries let me know, but I think people without scripting knowledge
        are capable of doing it.
    â¢   What you can undo / redo:
        - select / unselect element
        - delete / destroy / create / clone group
        - change position / rotation
        - set property
        - duplicate
        - create group from library
        - create cover group (not setting)    addEventHandler    onClientClick    root    browserOnClick    onClientCursorMove    onCursorMove    onClientBrowserCreated    resourceRoot    onBrowserCreate    onClientDoubleClick    onMyMouseDoubleClick     8   	   	   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
      3   5   5   5   5   5   5   6   6   6   6   6   6   7   7   7   7   7   7   8   8   8   8   8   8   :               <   ?            @@ @    @ À@ E   FÀ F Á @         mstu    help    gui    enableDxWindow    sub_help_elements        =   =   =   >   >   >   >   >   >   >   ?               A   D            @@ @    @ À@ E   FÀ F Á    @        mstu    help    gui    enableDxWindow    sub_help_elements        B   B   B   C   C   C   C   C   C   C   C   D               F   \      %      @@ @ E   F@À FÀÀ        @@  A @ @ d   À Á  @ À@ E   FÂ     À    B ÀB @    	@C   C B   @         mstu    gui    enableDxWindow    help_elements    closeSubWindows    help 	   setTimer       I@      ð?
   isElement    browser    destroy 	   showHelp     blockEditor        L   P            E     À@ A@AAÅ   ÆÀÀÆ ÁÆ@ÁÆÀÁ  B  \	@   	@A   @B B  @   
      mstu    browser    createBrowser    gui    browser_size       ð?      @      @   browserState    blockEditor        M   M   M   M   M   M   M   M   M   M   M   M   M   M   M   M   N   N   O   O   O   O   P           %   H   H   H   H   H   H   H   H   H   J   J   J   J   J   L   P   P   P   L   P   T   T   T   T   T   T   U   U   U   U   W   W   X   X   X   X   \               ^   e            E@  FÀ @  ÀÀ  E     Å@  Æ@Á  @@  E  \ 	@  	      source    mstu    browser    loadBrowserURL    http://www.youtube.com/embed/    tut_id )   ?rel=0&iv_load_policy=3&fs=0&disablekb=1 	   showHelp    getTickCount        `   `   `   `   `   a   a   a   a   a   a   a   a   b   b   b   b   e               g   m     /   F @ Z   
E@  \  @ M @  	EÀ    @AAÆÀA À  BÅ  Æ@ÁÆÁÁA Æ Æ@Â AAAFÁA ABE FAÁFÁÁA FFÁÂC ÁA B AB  ÁÂ Ã AÃ Ã Â \@     	   showHelp    getTickCount       Y@   dxDrawImage    mstu    gui    browser_size    browserState       ð?       @      @      @   browser            tocolor      ào@    /   i   i   i   i   i   i   i   i   i   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   j   m               o   {           @@   À    @@      ÀÀ @  Å   ÆÀ   @ @ Å   ÆÀ   @        mstu 	   showHelp    browser    down    injectBrowserMouseDown    injectBrowserMouseUp        q   q   q   q   q   q   q   q   r   u   u   v   v   v   v   v   v   x   x   x   x   x   {               }        
(     A@  À   @A        Á@ A  AAAAAA    Á E  FÁÀ ÁE  FAÁFÁFÁFÂZA    AÁ A Å  ÆÀMBA   
      mstu 	   showHelp    browser    browserState       ð?   gui    browser_size                @   injectBrowserMouseMove     (                                                                                                                                               	6   Å  ÆAÀÚ   @ Å  ÆÁÀW ÁÀ	Å  ÆAÁÆÁÆÁÁÆÁÁ@ÀÅ  ÆAÁÆÁÆÁÁÆÁÁ  BAAÂABÌÀ Å  ÆAÁÆÁÆÁÁÆÁÀÅ  ÆAÁÆÁÆÁÁÆÁ  BAAÂABBÌÀ Å  ÆÂÜA         mstu 	   showHelp    left    browserState        @   gui    browser_size       ð?      @      @   changeBrowserSizeState     6                                                                                                                                                                                                E   F@À À  AÀ  Z@    A  	@  E   F@Á    AÀAÅ   Æ@ÀÀ  BÅ   ÆÁÆÀÁ  A@Æ Æ@Â@   
      mstu    browserState       ð?       @   resizeBrowser    browser    gui    browser_size       @      @                                                                                                          ¦   ©            A@  @   À@  A @ Á Á A  @  	      setClipboard    thecrewgaming.com    exports    editor_gui    outputMessage    Copied link succesfully       I@      l@     X«@       §   §   §   ¨   ¨   ¨   ¨   ¨   ¨   ¨   ¨   ¨   ©               «   ®            A@  @   À@  A @ Á Á A  @  	      setClipboard '   https://www.youtube.com/user/2kristof2    exports    editor_gui    outputMessage    Copied link succesfully       I@      l@     X«@       ¬   ¬   ¬   ­   ­   ­   ­   ­   ­   ­   ­   ­   ®               °   ³            A@  @   À@  A @ Á Á A  @  	      setClipboard &   https://discordapp.com/invite/C4TRxr8    exports    editor_gui    outputMessage    Copied link succesfully       I@      l@     X«@       ±   ±   ±   ²   ²   ²   ²   ²   ²   ²   ²   ²   ³               µ   ¸            A@  @   À@  A @ Á Á A  @  	      setClipboard '   https://kr1s96.github.io/mstu/tutorial    exports    editor_gui    outputMessage    Copied link succesfully       I@      l@     X«@       ¶   ¶   ¶   ·   ·   ·   ·   ·   ·   ·   ·   ·   ¸               º   ½            A@  @   À@  A @ Á Á A  @  	      setClipboard (   https://www.buymeacoffee.com/CrazyStuff    exports    editor_gui    outputMessage    Copied link succesfully       I@      l@     X«@       »   »   »   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ¼   ½           /         :      <   ?   <   A   D   A   F   \   F   ^   e   ^   g   m   g   o   {   o   }      }                     ¦   ©   ¦   «   ®   «   °   ³   °   µ   ¸   µ   º   ½   º   ½                   I\NM[N8ìr<')ú|hMI=IlnmlsTÜ1>}L)ä|hMJ=Ilnmlmd9ì=,M|ÔLF}d,y¤\·UJñf%  V/ ÃÄ²9H7hÂÙêªDì4kÔ!¿öFí¥nB0V²^üYHR'VÛ«ÞN/1â¶ù.]ªbB