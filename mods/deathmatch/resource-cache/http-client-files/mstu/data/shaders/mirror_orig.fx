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

technique tec0
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
    }
}

// Fallback
technique fallback
{
    pass P0 { }
}