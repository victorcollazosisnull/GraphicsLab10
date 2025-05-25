Shader "Custom/MultitextureWithMask"
{
    Properties
    {
        _TexA ("Textura A", 2D) = "white" {}
        _TexB ("Textura B", 2D) = "white" {}
        _MaskTex ("Máscara (Escala de Grises)", 2D) = "gray" {}
        _AmbientColor ("Luz Ambiental", Color) = (0.2, 0.2, 0.2, 1)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _TexA;
            sampler2D _TexB;
            sampler2D _MaskTex;
            float4 _AmbientColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                float NdotL = max(0, dot(normal, lightDir));
                float3 diffuseLight = float3(NdotL, NdotL, NdotL);

                fixed4 texA = tex2D(_TexA, i.uv);
                fixed4 texB = tex2D(_TexB, i.uv);
                fixed mask = tex2D(_MaskTex, i.uv).r; 

                float3 blendedColor = lerp(texA.rgb, texB.rgb, mask);

                float3 finalColor = blendedColor * diffuseLight + _AmbientColor.rgb;

                return fixed4(finalColor, 1.0);
            }

            ENDCG
        }
    }
}