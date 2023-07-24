float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
float4x4 gWorldView : WORLDVIEW;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float4x4 gViewProjection : VIEWPROJECTION;
float4x4 gViewInverse : VIEWINVERSE;
float4x4 gWorldInverseTranspose : WORLDINVERSETRANSPOSE;
float4x4 gViewInverseTranspose : VIEWINVERSETRANSPOSE;

float3 gCameraPosition : CAMERAPOSITION;
float3 gCameraDirection : CAMERADIRECTION;

float gTime : TIME;


float4 gLightAmbient : LIGHTAMBIENT;
float4 gLightDiffuse : LIGHTDIFFUSE;
float4 gLightSpecular : LIGHTSPECULAR;
float3 gLightDirection : LIGHTDIRECTION;

int gLighting                      < string renderState="LIGHTING"; >;                        //  = 137,

float4 gGlobalAmbient              < string renderState="AMBIENT"; >;                    //  = 139,

int gDiffuseMaterialSource         < string renderState="DIFFUSEMATERIALSOURCE"; >;           //  = 145,
int gSpecularMaterialSource        < string renderState="SPECULARMATERIALSOURCE"; >;          //  = 146,
int gAmbientMaterialSource         < string renderState="AMBIENTMATERIALSOURCE"; >;           //  = 147,
int gEmissiveMaterialSource        < string renderState="EMISSIVEMATERIALSOURCE"; >;          //  = 148,

float4 gMaterialAmbient     < string materialState="Ambient"; >;
float4 gMaterialDiffuse     < string materialState="Diffuse"; >;
float4 gMaterialSpecular    < string materialState="Specular"; >;
float4 gMaterialEmissive    < string materialState="Emissive"; >;
float gMaterialSpecPower    < string materialState="Power"; >;

texture gTexture0           < string textureState="0,Texture"; >;
texture gTexture1           < string textureState="1,Texture"; >;
texture gTexture2           < string textureState="2,Texture"; >;
texture gTexture3           < string textureState="3,Texture"; >;

int gDeclNormal             < string vertexDeclState="Normal"; >;       // Set to 1 if vertex stream includes normals

float MTAUnlerp( float from, float to, float pos )
{
    if ( from == to )
        return 1.0;
    else
        return ( pos - from ) / ( to - from );
}

float4 MTACalcScreenPosition( float3 InPosition )
{
    float4 posWorld = mul(float4(InPosition,1), gWorld);
    float4 posWorldView = mul(posWorld, gView);
    return mul(posWorldView, gProjection);
}


float3 MTACalcWorldPosition( float3 InPosition )
{
    return mul(float4(InPosition,1), gWorld).xyz;
}

float3 MTACalcWorldNormal( float3 InNormal )
{
    return mul(InNormal, (float3x3)gWorld);
}

float4 MTACalcGTABuildingDiffuse( float4 InDiffuse )
{
    float4 OutDiffuse;

    if ( !gLighting )
    {
        // If lighting render state is off, pass through the vertex color
        OutDiffuse = InDiffuse;
    }
    else
    {
        // If lighting render state is on, calculate diffuse color by doing what D3D usually does
        float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
        float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
        float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;
        OutDiffuse = gGlobalAmbient * saturate( ambient + emissive );
        OutDiffuse.a *= diffuse.a;
    }
    return OutDiffuse;
}

float4 MTACalcGTAVehicleDiffuse( float3 WorldNormal, float4 InDiffuse )
{
    // Calculate diffuse color by doing what D3D usually does
    float4 ambient  = gAmbientMaterialSource  == 0 ? gMaterialAmbient  : InDiffuse;
    float4 diffuse  = gDiffuseMaterialSource  == 0 ? gMaterialDiffuse  : InDiffuse;
    float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse;

    float4 TotalAmbient = ambient * ( gGlobalAmbient + gLightAmbient );

    // Add the strongest light
    float DirectionFactor = max(0,dot(WorldNormal, -gLightDirection ));
    float4 TotalDiffuse = ( diffuse * gLightDiffuse * DirectionFactor );

    float4 OutDiffuse = saturate(TotalDiffuse + TotalAmbient + emissive);
    OutDiffuse.a *= diffuse.a;

    return OutDiffuse;
}

float3 MTACalculateCameraDirection( float3 CamPos, float3 InWorldPos )
{
    return normalize( InWorldPos - CamPos );
}

float MTACalcCameraDistance( float3 CamPos, float3 InWorldPos )
{
    return distance( InWorldPos, CamPos );
}

float MTACalculateSpecular( float3 CamDir, float3 LightDir, float3 SurfNormal, float SpecPower )
{
    // Using Blinn half angle modification for performance over correctness
    LightDir = normalize(LightDir);
    SurfNormal = normalize(SurfNormal);
    float3 halfAngle = normalize(-CamDir - LightDir);
    float r = dot(halfAngle, SurfNormal);
    return pow(saturate(r), SpecPower);
}

int CUSTOMFLAGS
<
#ifdef GENERATE_NORMALS
    string createNormals = "yes";           // Some models do not have normals by default. Setting this to 'yes' will add them to the VertexShaderInput as NORMAL0
#endif
    string skipUnusedParameters = "yes";    // This will make the shader a bit faster
>;

void MTAFixUpNormal( in out float3 OutNormal )
{
    // Incase we have no normal inputted
    if ( OutNormal.x == 0 && OutNormal.y == 0 && OutNormal.z == 0 )
        OutNormal = float3(0,0,1);   // Default to up
}

texture sSkyBoxTexture1;
float gBrighten = 0;
float gEnAlpha = 0;
float gInvertTimeCycle = 0;

float rotateX=0;
float rotateY=0;
float rotateZ=0;
float animate=0;
float3 sResize={0,0,0};
float3 sStretch=(0,0,0);

samplerCUBE envMapSampler1 = sampler_state
{
    Texture = (sSkyBoxTexture1);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    MIPMAPLODBIAS = 0.000000;
};

 struct VSInput
{
    float4 Position : POSITION; 
    float3 TexCoord : TEXCOORD0;
	float3 Normal : NORMAL0;
};

struct PSInput
{
    float4 Position : POSITION; 
    float3 TexCoord : TEXCOORD0;	
};

PSInput VertexShaderSB(VSInput VS)
{
    PSInput PS = (PSInput)0;
 
	// Resize by multiplying vertex position
	VS.Position *=float4(sResize,1);
    // Position in screen space.
    PS.Position = mul(VS.Position, gWorldViewProjection);

    // compute the 4x4 tranform from tangent space to object space
    float4 worldPos = mul(VS.Position, gWorld);
	worldPos.xyz*=sStretch;
    // compute the eye vector 
    float4 eyeVector = worldPos - gViewInverse[3]; 
	
	float time;
	if (animate!=0) {time=gTime;} else {time=1;}
	float cosX,sinX;
	float cosY,sinY;
	float cosZ,sinZ;

	// Rotate the texture
	sincos(rotateX * time,sinX,cosX);
	sincos(rotateY * time,sinY,cosY);
	sincos(rotateZ * time,sinZ,cosZ);

	float3x3 rot = float3x3(
      cosY * cosZ + sinX * sinY * sinZ, -cosX * sinZ,  sinX * cosY * sinZ - sinY * cosZ,
      cosY * sinZ - sinX * sinY * cosZ,  cosX * cosZ, -sinY * sinZ - sinX * cosY * cosZ,
      cosX * sinY,                       sinX,         cosX * cosY
	);


   PS.TexCoord.xyz = mul(rot, eyeVector.xyz);

    return PS;
}
 
float4 PixelShaderSB(PSInput PS) : COLOR0
{
    float3 eyevec = normalize(float3(PS.TexCoord.x, PS.TexCoord.z, PS.TexCoord.y));
    float4 outPut = texCUBE(envMapSampler1, eyevec);
	
	 if (gInvertTimeCycle!=0)
	 {
	  outPut.rgba = outPut.rgba -(1+ gBrighten); 
	 }
	 else
	 {
	  outPut.rgba = outPut.rgba + gBrighten; 
	 }
	 if(gEnAlpha==0) {outPut.a=1;}
 
    return outPut;
}

technique SkyBox_2
{
    pass P0
    {
	    AlphaBlendEnable = TRUE;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
        VertexShader = compile vs_2_0 VertexShaderSB();
        PixelShader = compile ps_2_0 PixelShaderSB();
    }
}
