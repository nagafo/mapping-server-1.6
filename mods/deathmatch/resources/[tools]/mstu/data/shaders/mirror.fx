/*
 *  Mirror shader by Xiti
 *  Thanks to Krzysztof for motivation
 *  Contact:    https://xistudio.pw, https://thecrewgaming.com,
 *  Discord:    Xiti#5118
 */


bool mirrorX = false;
bool mirrorY = false;
bool mirrorZ = false;

#include "mta-helper.fx"

sampler Sampler0 = sampler_state
{
    Texture         = (gTexture0);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------

float4 sColorize : COLORIZE;

struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    if(mirrorX) {
        VS.Position.x *= -1;
    }

    if(mirrorY) {
        VS.Position.y *= -1;
    }

    if(mirrorZ) {
        VS.Position.z *= -1;
    }

    PS.Position = MTACalcScreenPosition ( VS.Position );
    PS.TexCoord = VS.TexCoord;
    PS.Diffuse = MTACalcGTABuildingDiffuse( VS.Diffuse );

    return PS;
}

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
	float4 texel = tex2D(Sampler0, PS.TexCoord);
    float alpha = tex2D(Sampler0, PS.TexCoord).a;

    // Modulate texture with lighting and colorization value
    float4 finalColor = texel * PS.Diffuse * sColorize;
    finalColor.a = alpha * PS.Diffuse.a;

    return finalColor;
}

technique tec0
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

// Fallback
technique fallback
{
    pass P0 { }
}
