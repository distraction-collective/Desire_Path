// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Terrain_Gneh"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HideInInspector]_Colormaphehe("Colormaphehe", 2D) = "white" {}
		[HideInInspector]_Splatmaphehe("Splatmaphehe", 2D) = "white" {}
		[HideInInspector]_Smoothness0("Smoothness0", Range( 0 , 1)) = 0
		[HideInInspector]_Smoothness1("Smoothness1", Range( 0 , 1)) = 0
		[HideInInspector]_Smoothness2("Smoothness2", Range( 0 , 1)) = 0
		[HideInInspector]_Smoothness3("Smoothness3", Range( 0 , 1)) = 0
		[HideInInspector]_Splat2("Splat2", 2D) = "white" {}
		[HideInInspector]_Normal2("Normal2", 2D) = "white" {}
		[HideInInspector]_NormalScale1("NormalScale1", Float) = 2.5
		[HideInInspector]_NormalScale0("NormalScale0", Float) = 2.5
		[HideInInspector]_NormalScale3("NormalScale2", Float) = 2.5
		[HideInInspector]_NormalScale2("NormalScale2", Float) = 2.5
		[HideInInspector]_Splat3("Splat3", 2D) = "white" {}
		[HideInInspector]_Normal3("Normal3", 2D) = "white" {}
		[HideInInspector]_Splat1("Splat1", 2D) = "white" {}
		[HideInInspector]_Normal1("Normal1", 2D) = "white" {}
		[HideInInspector]_Splat0("Splat0", 2D) = "white" {}
		[HideInInspector]_Normal0("Normal0", 2D) = "bump" {}
		[HideInInspector][Gamma]_Metallic0("Metallic0", Range( 0 , 1)) = 0
		[HideInInspector]_AmbiantOcclusion0("AmbiantOcclusion0", Range( 0 , 1)) = 0.3318382
		[HideInInspector][Gamma]_Metallic2("Metallic2", Range( 0 , 1)) = 0
		[HideInInspector][Gamma]_Metallic3("Metallic3", Range( 0 , 1)) = 0
		[HideInInspector][Gamma]_Metallic1("Metallic1", Range( 0 , 1)) = 0
		[HideInInspector]_struggle_map("struggle_map", 2D) = "white" {}
		_AnimationSpeed("AnimationSpeed", Range( 0 , 2)) = 0
		[HDR]_Emission("Emission", Color) = (7.975868,7.780234,7.780234,0)
		_Noise_Emission("Noise_Emission", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		[HideInInspector][ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[HideInInspector][ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0
		[HideInInspector][ToggleOff] _ReceiveShadows("Receive Shadows", Float) = 1.0

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" "UniversalMaterialType"="Lit" }

		Cull Back
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		AlphaToMask Off

		

		HLSLINCLUDE
		#pragma target 4.5
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}

		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS
		ENDHLSL

		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
	UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"

		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			

			HLSLPROGRAM

			#pragma instancing_options renderinglayer
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#pragma multi_compile _ _FORWARD_PLUS

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float4 lightmapUVOrVertexSH : TEXCOORD1;
				half4 fogFactorAndVertexLight : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					float4 shadowCoord : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _struggle_map_ST;
			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splatmaphehe_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;
			float4 _Colormaphehe_ST;
			float4 _Noise_Emission_ST;
			float4 _Emission;
			float4 _Normal2_ST;
			float _Smoothness2;
			float _Smoothness1;
			float _Smoothness0;
			float _Metallic3;
			float _Metallic2;
			float _Metallic1;
			float _NormalScale1;
			float _NormalScale3;
			float _NormalScale2;
			float _Smoothness3;
			float _NormalScale0;
			float _AnimationSpeed;
			float _Metallic0;
			float _AmbiantOcclusion0;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_struggle_map);
			SAMPLER(sampler_struggle_map);
			TEXTURE2D(_Splat0);
			SAMPLER(sampler_Splat0);
			TEXTURE2D(_Splat1);
			SAMPLER(sampler_Splat1);
			TEXTURE2D(_Splatmaphehe);
			SAMPLER(sampler_Splatmaphehe);
			TEXTURE2D(_Splat2);
			SAMPLER(sampler_Splat2);
			TEXTURE2D(_Splat3);
			SAMPLER(sampler_Splat3);
			TEXTURE2D(_Colormaphehe);
			SAMPLER(sampler_Colormaphehe);
			TEXTURE2D(_Noise_Emission);
			SAMPLER(sampler_Noise_Emission);
			TEXTURE2D(_Normal0);
			SAMPLER(sampler_Normal0);
			TEXTURE2D(_Normal1);
			SAMPLER(sampler_Normal1);
			TEXTURE2D(_Normal2);
			SAMPLER(sampler_Normal2);
			TEXTURE2D(_Normal3);
			SAMPLER(sampler_Normal3);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			void StochasticTiling( float2 UV, out float2 UV1, out float2 UV2, out float2 UV3, out float W1, out float W2, out float W3 )
			{
				float2 vertex1, vertex2, vertex3;
				// Scaling of the input
				float2 uv = UV * 3.464; // 2 * sqrt (3)
				// Skew input space into simplex triangle grid
				const float2x2 gridToSkewedGrid = float2x2( 1.0, 0.0, -0.57735027, 1.15470054 );
				float2 skewedCoord = mul( gridToSkewedGrid, uv );
				// Compute local triangle vertex IDs and local barycentric coordinates
				int2 baseId = int2( floor( skewedCoord ) );
				float3 temp = float3( frac( skewedCoord ), 0 );
				temp.z = 1.0 - temp.x - temp.y;
				if ( temp.z > 0.0 )
				{
					W1 = temp.z;
					W2 = temp.y;
					W3 = temp.x;
					vertex1 = baseId;
					vertex2 = baseId + int2( 0, 1 );
					vertex3 = baseId + int2( 1, 0 );
				}
				else
				{
					W1 = -temp.z;
					W2 = 1.0 - temp.y;
					W3 = 1.0 - temp.x;
					vertex1 = baseId + int2( 1, 1 );
					vertex2 = baseId + int2( 1, 0 );
					vertex3 = baseId + int2( 0, 1 );
				}
				UV1 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex1 ) ) * 43758.5453 );
				UV2 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex2 ) ) * 43758.5453 );
				UV3 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex3 ) ) * 43758.5453 );
				return;
			}
			
			VertexInput ApplyMeshModification( VertexInput v )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				v.vertex.xz = sampleCoords* _TerrainHeightmapScale.xz;
				v.vertex.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					v.ase_normal = float3(0, 1, 0);
				#else
					v.ase_normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				v.texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
				return v;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				v = ApplyMeshModification(v);
				float2 uv_struggle_map = v.texcoord.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D_LOD( _struggle_map, sampler_struggle_map, uv_struggle_map, 0.0 ).g );
				float3 appendResult224 = (float3(0.0 , ( temp_output_159_0 * 0.0 ) , 0.0));
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = appendResult224;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord.xy;
					o.lightmapUVOrVertexSH.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif

				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float localStochasticTiling2_g17 = ( 0.0 );
				float2 uv_Splat0 = IN.ase_texcoord8.xy * _Splat0_ST.xy + _Splat0_ST.zw;
				float2 Input_UV145_g17 = uv_Splat0;
				float2 UV2_g17 = Input_UV145_g17;
				float2 UV12_g17 = float2( 0,0 );
				float2 UV22_g17 = float2( 0,0 );
				float2 UV32_g17 = float2( 0,0 );
				float W12_g17 = 0.0;
				float W22_g17 = 0.0;
				float W32_g17 = 0.0;
				StochasticTiling( UV2_g17 , UV12_g17 , UV22_g17 , UV32_g17 , W12_g17 , W22_g17 , W32_g17 );
				float2 temp_output_10_0_g17 = ddx( Input_UV145_g17 );
				float2 temp_output_12_0_g17 = ddy( Input_UV145_g17 );
				float4 Output_2D293_g17 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV12_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W12_g17 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV22_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W22_g17 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV32_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W32_g17 ) );
				float localStochasticTiling2_g2 = ( 0.0 );
				float2 uv_Splat1 = IN.ase_texcoord8.xy * _Splat1_ST.xy + _Splat1_ST.zw;
				float2 Input_UV145_g2 = uv_Splat1;
				float2 UV2_g2 = Input_UV145_g2;
				float2 UV12_g2 = float2( 0,0 );
				float2 UV22_g2 = float2( 0,0 );
				float2 UV32_g2 = float2( 0,0 );
				float W12_g2 = 0.0;
				float W22_g2 = 0.0;
				float W32_g2 = 0.0;
				StochasticTiling( UV2_g2 , UV12_g2 , UV22_g2 , UV32_g2 , W12_g2 , W22_g2 , W32_g2 );
				float2 temp_output_10_0_g2 = ddx( Input_UV145_g2 );
				float2 temp_output_12_0_g2 = ddy( Input_UV145_g2 );
				float4 Output_2D293_g2 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV12_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W12_g2 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV22_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W22_g2 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV32_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W32_g2 ) );
				float2 uv_Splatmaphehe = IN.ase_texcoord8.xy * _Splatmaphehe_ST.xy + _Splatmaphehe_ST.zw;
				float4 tex2DNode33 = SAMPLE_TEXTURE2D( _Splatmaphehe, sampler_Splatmaphehe, uv_Splatmaphehe );
				float Splat_R83 = tex2DNode33.r;
				float4 lerpResult45 = lerp( Output_2D293_g17 , Output_2D293_g2 , Splat_R83);
				float localStochasticTiling2_g3 = ( 0.0 );
				float2 uv_Splat2 = IN.ase_texcoord8.xy * _Splat2_ST.xy + _Splat2_ST.zw;
				float2 Input_UV145_g3 = uv_Splat2;
				float2 UV2_g3 = Input_UV145_g3;
				float2 UV12_g3 = float2( 0,0 );
				float2 UV22_g3 = float2( 0,0 );
				float2 UV32_g3 = float2( 0,0 );
				float W12_g3 = 0.0;
				float W22_g3 = 0.0;
				float W32_g3 = 0.0;
				StochasticTiling( UV2_g3 , UV12_g3 , UV22_g3 , UV32_g3 , W12_g3 , W22_g3 , W32_g3 );
				float2 temp_output_10_0_g3 = ddx( Input_UV145_g3 );
				float2 temp_output_12_0_g3 = ddy( Input_UV145_g3 );
				float4 Output_2D293_g3 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV12_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W12_g3 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV22_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W22_g3 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV32_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W32_g3 ) );
				float Splat_G84 = tex2DNode33.g;
				float4 lerpResult46 = lerp( lerpResult45 , Output_2D293_g3 , Splat_G84);
				float localStochasticTiling2_g4 = ( 0.0 );
				float2 uv_Splat3 = IN.ase_texcoord8.xy * _Splat3_ST.xy + _Splat3_ST.zw;
				float2 Input_UV145_g4 = uv_Splat3;
				float2 UV2_g4 = Input_UV145_g4;
				float2 UV12_g4 = float2( 0,0 );
				float2 UV22_g4 = float2( 0,0 );
				float2 UV32_g4 = float2( 0,0 );
				float W12_g4 = 0.0;
				float W22_g4 = 0.0;
				float W32_g4 = 0.0;
				StochasticTiling( UV2_g4 , UV12_g4 , UV22_g4 , UV32_g4 , W12_g4 , W22_g4 , W32_g4 );
				float2 temp_output_10_0_g4 = ddx( Input_UV145_g4 );
				float2 temp_output_12_0_g4 = ddy( Input_UV145_g4 );
				float4 Output_2D293_g4 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV12_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W12_g4 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV22_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W22_g4 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV32_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W32_g4 ) );
				float Splat_B85 = tex2DNode33.b;
				float4 lerpResult47 = lerp( lerpResult46 , Output_2D293_g4 , Splat_B85);
				float3 desaturateInitialColor49 = lerpResult47.rgb;
				float desaturateDot49 = dot( desaturateInitialColor49, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar49 = lerp( desaturateInitialColor49, desaturateDot49.xxx, 1.0 );
				float2 uv_Colormaphehe = IN.ase_texcoord8.xy * _Colormaphehe_ST.xy + _Colormaphehe_ST.zw;
				float4 tex2DNode10 = SAMPLE_TEXTURE2D( _Colormaphehe, sampler_Colormaphehe, uv_Colormaphehe );
				float grayscale167 = Luminance(tex2DNode10.rgb);
				float4 temp_cast_3 = (grayscale167).xxxx;
				float4 lerpResult168 = lerp( tex2DNode10 , temp_cast_3 , float4( 0.7924528,0.7924528,0.7924528,0 ));
				float4 temp_output_52_0 = ( ( float4( desaturateVar49 , 0.0 ) * lerpResult168 ) * 3.0 );
				float temp_output_199_0 = ( _TimeParameters.x * _AnimationSpeed );
				float2 appendResult177 = (float2(0.0 , ( temp_output_199_0 * 0.1 )));
				float2 texCoord174 = IN.ase_texcoord8.xy * ( _Noise_Emission_ST.xy * float2( 150,150 ) ) + appendResult177;
				float2 appendResult182 = (float2(( temp_output_199_0 * 0.2 ) , 0.0));
				float2 texCoord180 = IN.ase_texcoord8.xy * ( _Noise_Emission_ST.xy * float2( 100,100 ) ) + appendResult182;
				float2 appendResult193 = (float2(0.0 , ( temp_output_199_0 * 0.3 )));
				float2 texCoord192 = IN.ase_texcoord8.xy * ( _Noise_Emission_ST.xy * float2( 50,50 ) ) + appendResult193;
				float noisepath202 = ( ( ( ( SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord174 ).r * SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord180 ).r ) * SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord192 ).r ) * 10.0 ) + 0.1 );
				float2 uv_struggle_map = IN.ase_texcoord8.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D( _struggle_map, sampler_struggle_map, uv_struggle_map ).g );
				float temp_output_234_0 = saturate( temp_output_159_0 );
				float4 lerpResult162 = lerp( ( temp_output_52_0 * ( noisepath202 * _Emission ) ) , temp_output_52_0 , temp_output_234_0);
				float localStochasticTiling2_g19 = ( 0.0 );
				float2 Input_UV145_g19 = uv_Splat0;
				float2 UV2_g19 = Input_UV145_g19;
				float2 UV12_g19 = float2( 0,0 );
				float2 UV22_g19 = float2( 0,0 );
				float2 UV32_g19 = float2( 0,0 );
				float W12_g19 = 0.0;
				float W22_g19 = 0.0;
				float W32_g19 = 0.0;
				StochasticTiling( UV2_g19 , UV12_g19 , UV22_g19 , UV32_g19 , W12_g19 , W22_g19 , W32_g19 );
				float2 temp_output_10_0_g19 = ddx( Input_UV145_g19 );
				float2 temp_output_12_0_g19 = ddy( Input_UV145_g19 );
				float4 Output_2D293_g19 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV12_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W12_g19 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV22_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W22_g19 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV32_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W32_g19 ) );
				float3 unpack144 = UnpackNormalScale( Output_2D293_g19, _NormalScale0 );
				unpack144.z = lerp( 1, unpack144.z, saturate(_NormalScale0) );
				float localStochasticTiling2_g15 = ( 0.0 );
				float2 Input_UV145_g15 = uv_Splat1;
				float2 UV2_g15 = Input_UV145_g15;
				float2 UV12_g15 = float2( 0,0 );
				float2 UV22_g15 = float2( 0,0 );
				float2 UV32_g15 = float2( 0,0 );
				float W12_g15 = 0.0;
				float W22_g15 = 0.0;
				float W32_g15 = 0.0;
				StochasticTiling( UV2_g15 , UV12_g15 , UV22_g15 , UV32_g15 , W12_g15 , W22_g15 , W32_g15 );
				float2 temp_output_10_0_g15 = ddx( Input_UV145_g15 );
				float2 temp_output_12_0_g15 = ddy( Input_UV145_g15 );
				float4 Output_2D293_g15 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV12_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W12_g15 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV22_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W22_g15 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV32_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W32_g15 ) );
				float3 unpack147 = UnpackNormalScale( Output_2D293_g15, _NormalScale1 );
				unpack147.z = lerp( 1, unpack147.z, saturate(_NormalScale1) );
				float3 lerpResult98 = lerp( unpack144 , unpack147 , Splat_R83);
				float localStochasticTiling2_g16 = ( 0.0 );
				float2 uv_Normal2 = IN.ase_texcoord8.xy * _Normal2_ST.xy + _Normal2_ST.zw;
				float2 Input_UV145_g16 = uv_Normal2;
				float2 UV2_g16 = Input_UV145_g16;
				float2 UV12_g16 = float2( 0,0 );
				float2 UV22_g16 = float2( 0,0 );
				float2 UV32_g16 = float2( 0,0 );
				float W12_g16 = 0.0;
				float W22_g16 = 0.0;
				float W32_g16 = 0.0;
				StochasticTiling( UV2_g16 , UV12_g16 , UV22_g16 , UV32_g16 , W12_g16 , W22_g16 , W32_g16 );
				float2 temp_output_10_0_g16 = ddx( Input_UV145_g16 );
				float2 temp_output_12_0_g16 = ddy( Input_UV145_g16 );
				float4 Output_2D293_g16 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV12_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W12_g16 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV22_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W22_g16 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV32_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W32_g16 ) );
				float3 unpack149 = UnpackNormalScale( Output_2D293_g16, _NormalScale2 );
				unpack149.z = lerp( 1, unpack149.z, saturate(_NormalScale2) );
				float3 lerpResult99 = lerp( lerpResult98 , unpack149 , Splat_G84);
				float localStochasticTiling2_g18 = ( 0.0 );
				float2 Input_UV145_g18 = uv_Splat3;
				float2 UV2_g18 = Input_UV145_g18;
				float2 UV12_g18 = float2( 0,0 );
				float2 UV22_g18 = float2( 0,0 );
				float2 UV32_g18 = float2( 0,0 );
				float W12_g18 = 0.0;
				float W22_g18 = 0.0;
				float W32_g18 = 0.0;
				StochasticTiling( UV2_g18 , UV12_g18 , UV22_g18 , UV32_g18 , W12_g18 , W22_g18 , W32_g18 );
				float2 temp_output_10_0_g18 = ddx( Input_UV145_g18 );
				float2 temp_output_12_0_g18 = ddy( Input_UV145_g18 );
				float4 Output_2D293_g18 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV12_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W12_g18 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV22_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W22_g18 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV32_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W32_g18 ) );
				float3 unpack152 = UnpackNormalScale( Output_2D293_g18, _NormalScale3 );
				unpack152.z = lerp( 1, unpack152.z, saturate(_NormalScale3) );
				float3 lerpResult100 = lerp( lerpResult99 , unpack152 , Splat_B85);
				float3 temp_output_166_0 = ( lerpResult100 + temp_output_234_0 );
				float3 temp_output_245_0 = SHADERGRAPH_REFLECTION_PROBE(float3( 0,0,0 ),temp_output_166_0,0.0);
				
				float lerpResult128 = lerp( _Metallic0 , _Metallic1 , Splat_R83);
				float lerpResult131 = lerp( lerpResult128 , _Metallic2 , Splat_G84);
				float lerpResult133 = lerp( lerpResult131 , _Metallic3 , Splat_B85);
				
				float lerpResult119 = lerp( _Smoothness0 , _Smoothness1 , Splat_R83);
				float lerpResult122 = lerp( lerpResult119 , _Smoothness2 , Splat_G84);
				float lerpResult124 = lerp( lerpResult122 , _Smoothness3 , Splat_B85);
				

				float3 BaseColor = ( lerpResult162 + float4( ( temp_output_245_0 * float3( 0.1,0.1,0.1 ) ) , 0.0 ) ).rgb;
				float3 Normal = temp_output_166_0;
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = lerpResult133;
				float Smoothness = lerpResult124;
				float Occlusion = _AmbiantOcclusion0;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _CLEARCOAT
					float CoatMask = 0;
					float CoatSmoothness = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;

				#ifdef _NORMALMAP
						#if _NORMAL_DROPOFF_TS
							inputData.normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent, WorldBiTangent, WorldNormal));
						#elif _NORMAL_DROPOFF_OS
							inputData.normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							inputData.normalWS = Normal;
						#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					inputData.shadowCoord = ShadowCoords;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
				#else
					inputData.shadowCoord = float4(0, 0, 0, 0);
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif
					inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
				#else
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
					#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				SurfaceData surfaceData;
				surfaceData.albedo              = BaseColor;
				surfaceData.metallic            = saturate(Metallic);
				surfaceData.specular            = Specular;
				surfaceData.smoothness          = saturate(Smoothness),
				surfaceData.occlusion           = Occlusion,
				surfaceData.emission            = Emission,
				surfaceData.alpha               = saturate(Alpha);
				surfaceData.normalTS            = Normal;
				surfaceData.clearCoatMask       = 0;
				surfaceData.clearCoatSmoothness = 1;

				#ifdef _CLEARCOAT
					surfaceData.clearCoatMask       = saturate(CoatMask);
					surfaceData.clearCoatSmoothness = saturate(CoatSmoothness);
				#endif

				#ifdef _DBUFFER
					ApplyDecalToSurfaceData(IN.clipPos, surfaceData, inputData);
				#endif

				half4 color = UniversalFragmentPBR( inputData, surfaceData);

				#ifdef ASE_TRANSMISSION
				{
					float shadow = _TransmissionShadow;

					#define SUM_LIGHT_TRANSMISSION(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 transmission = max( 0, -dot( inputData.normalWS, Light.direction ) ) * atten * Transmission;\
						color.rgb += BaseColor * transmission;

					SUM_LIGHT_TRANSMISSION( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_FORWARD_PLUS
							for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSMISSION( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSMISSION( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_TRANSLUCENCY
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					#define SUM_LIGHT_TRANSLUCENCY(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 lightDir = Light.direction + inputData.normalWS * normal;\
						half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );\
						half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;\
						color.rgb += BaseColor * translucency * strength;

					SUM_LIGHT_TRANSLUCENCY( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_FORWARD_PLUS
							for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSLUCENCY( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSLUCENCY( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_REFRACTION
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, float4( WorldNormal,0 ) ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos.xy ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
				#endif

				return color;
			}

			ENDHLSL
		}

		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
	UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"

		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off
			ColorMask 0

			HLSLPROGRAM

			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD1;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD2;
				#endif				
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _struggle_map_ST;
			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splatmaphehe_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;
			float4 _Colormaphehe_ST;
			float4 _Noise_Emission_ST;
			float4 _Emission;
			float4 _Normal2_ST;
			float _Smoothness2;
			float _Smoothness1;
			float _Smoothness0;
			float _Metallic3;
			float _Metallic2;
			float _Metallic1;
			float _NormalScale1;
			float _NormalScale3;
			float _NormalScale2;
			float _Smoothness3;
			float _NormalScale0;
			float _AnimationSpeed;
			float _Metallic0;
			float _AmbiantOcclusion0;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_struggle_map);
			SAMPLER(sampler_struggle_map);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			VertexInput ApplyMeshModification( VertexInput v )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				v.vertex.xz = sampleCoords* _TerrainHeightmapScale.xz;
				v.vertex.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					v.ase_normal = float3(0, 1, 0);
				#else
					v.ase_normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				v.ase_texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
				return v;
			}
			

			float3 _LightDirection;
			float3 _LightPosition;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				v = ApplyMeshModification(v);
				float2 uv_struggle_map = v.ase_texcoord.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D_LOD( _struggle_map, sampler_struggle_map, uv_struggle_map, 0.0 ).g );
				float3 appendResult224 = (float3(0.0 , ( temp_output_159_0 * 0.0 ) , 0.0));
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = appendResult224;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				#if _CASTING_PUNCTUAL_LIGHT_SHADOW
					float3 lightDirectionWS = normalize(_LightPosition - positionWS);
				#else
					float3 lightDirectionWS = _LightDirection;
				#endif

				float4 clipPos = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = clipPos;
				o.clipPosV = clipPos;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				

				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
	UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"

		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask R
			AlphaToMask Off

			HLSLPROGRAM

			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			
			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD1;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _struggle_map_ST;
			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splatmaphehe_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;
			float4 _Colormaphehe_ST;
			float4 _Noise_Emission_ST;
			float4 _Emission;
			float4 _Normal2_ST;
			float _Smoothness2;
			float _Smoothness1;
			float _Smoothness0;
			float _Metallic3;
			float _Metallic2;
			float _Metallic1;
			float _NormalScale1;
			float _NormalScale3;
			float _NormalScale2;
			float _Smoothness3;
			float _NormalScale0;
			float _AnimationSpeed;
			float _Metallic0;
			float _AmbiantOcclusion0;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_struggle_map);
			SAMPLER(sampler_struggle_map);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			VertexInput ApplyMeshModification( VertexInput v )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				v.vertex.xz = sampleCoords* _TerrainHeightmapScale.xz;
				v.vertex.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					v.ase_normal = float3(0, 1, 0);
				#else
					v.ase_normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				v.ase_texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
				return v;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				v = ApplyMeshModification(v);
				float2 uv_struggle_map = v.ase_texcoord.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D_LOD( _struggle_map, sampler_struggle_map, uv_struggle_map, 0.0 ).g );
				float3 appendResult224 = (float3(0.0 , ( temp_output_159_0 * 0.0 ) , 0.0));
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = appendResult224;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				

				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
	UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"

		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#pragma shader_feature EDITOR_VISUALIZATION

			#define SHADERPASS SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef EDITOR_VISUALIZATION
					float4 VizUV : TEXCOORD2;
					float4 LightCoord : TEXCOORD3;
				#endif
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _struggle_map_ST;
			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splatmaphehe_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;
			float4 _Colormaphehe_ST;
			float4 _Noise_Emission_ST;
			float4 _Emission;
			float4 _Normal2_ST;
			float _Smoothness2;
			float _Smoothness1;
			float _Smoothness0;
			float _Metallic3;
			float _Metallic2;
			float _Metallic1;
			float _NormalScale1;
			float _NormalScale3;
			float _NormalScale2;
			float _Smoothness3;
			float _NormalScale0;
			float _AnimationSpeed;
			float _Metallic0;
			float _AmbiantOcclusion0;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_struggle_map);
			SAMPLER(sampler_struggle_map);
			TEXTURE2D(_Splat0);
			SAMPLER(sampler_Splat0);
			TEXTURE2D(_Splat1);
			SAMPLER(sampler_Splat1);
			TEXTURE2D(_Splatmaphehe);
			SAMPLER(sampler_Splatmaphehe);
			TEXTURE2D(_Splat2);
			SAMPLER(sampler_Splat2);
			TEXTURE2D(_Splat3);
			SAMPLER(sampler_Splat3);
			TEXTURE2D(_Colormaphehe);
			SAMPLER(sampler_Colormaphehe);
			TEXTURE2D(_Noise_Emission);
			SAMPLER(sampler_Noise_Emission);
			TEXTURE2D(_Normal0);
			SAMPLER(sampler_Normal0);
			TEXTURE2D(_Normal1);
			SAMPLER(sampler_Normal1);
			TEXTURE2D(_Normal2);
			SAMPLER(sampler_Normal2);
			TEXTURE2D(_Normal3);
			SAMPLER(sampler_Normal3);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			void StochasticTiling( float2 UV, out float2 UV1, out float2 UV2, out float2 UV3, out float W1, out float W2, out float W3 )
			{
				float2 vertex1, vertex2, vertex3;
				// Scaling of the input
				float2 uv = UV * 3.464; // 2 * sqrt (3)
				// Skew input space into simplex triangle grid
				const float2x2 gridToSkewedGrid = float2x2( 1.0, 0.0, -0.57735027, 1.15470054 );
				float2 skewedCoord = mul( gridToSkewedGrid, uv );
				// Compute local triangle vertex IDs and local barycentric coordinates
				int2 baseId = int2( floor( skewedCoord ) );
				float3 temp = float3( frac( skewedCoord ), 0 );
				temp.z = 1.0 - temp.x - temp.y;
				if ( temp.z > 0.0 )
				{
					W1 = temp.z;
					W2 = temp.y;
					W3 = temp.x;
					vertex1 = baseId;
					vertex2 = baseId + int2( 0, 1 );
					vertex3 = baseId + int2( 1, 0 );
				}
				else
				{
					W1 = -temp.z;
					W2 = 1.0 - temp.y;
					W3 = 1.0 - temp.x;
					vertex1 = baseId + int2( 1, 1 );
					vertex2 = baseId + int2( 1, 0 );
					vertex3 = baseId + int2( 0, 1 );
				}
				UV1 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex1 ) ) * 43758.5453 );
				UV2 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex2 ) ) * 43758.5453 );
				UV3 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex3 ) ) * 43758.5453 );
				return;
			}
			
			VertexInput ApplyMeshModification( VertexInput v )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				v.vertex.xz = sampleCoords* _TerrainHeightmapScale.xz;
				v.vertex.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					v.ase_normal = float3(0, 1, 0);
				#else
					v.ase_normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				v.texcoord0.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
				return v;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				v = ApplyMeshModification(v);
				float2 uv_struggle_map = v.texcoord0.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D_LOD( _struggle_map, sampler_struggle_map, uv_struggle_map, 0.0 ).g );
				float3 appendResult224 = (float3(0.0 , ( temp_output_159_0 * 0.0 ) , 0.0));
				
				o.ase_texcoord4.xy = v.texcoord0.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = appendResult224;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );

				#ifdef EDITOR_VISUALIZATION
					float2 VizUV = 0;
					float4 LightCoord = 0;
					UnityEditorVizData(v.vertex.xyz, v.texcoord0.xy, v.texcoord1.xy, v.texcoord2.xy, VizUV, LightCoord);
					o.VizUV = float4(VizUV, 0, 0);
					o.LightCoord = LightCoord;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.texcoord0 = v.texcoord0;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.texcoord0 = patch[0].texcoord0 * bary.x + patch[1].texcoord0 * bary.y + patch[2].texcoord0 * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float localStochasticTiling2_g17 = ( 0.0 );
				float2 uv_Splat0 = IN.ase_texcoord4.xy * _Splat0_ST.xy + _Splat0_ST.zw;
				float2 Input_UV145_g17 = uv_Splat0;
				float2 UV2_g17 = Input_UV145_g17;
				float2 UV12_g17 = float2( 0,0 );
				float2 UV22_g17 = float2( 0,0 );
				float2 UV32_g17 = float2( 0,0 );
				float W12_g17 = 0.0;
				float W22_g17 = 0.0;
				float W32_g17 = 0.0;
				StochasticTiling( UV2_g17 , UV12_g17 , UV22_g17 , UV32_g17 , W12_g17 , W22_g17 , W32_g17 );
				float2 temp_output_10_0_g17 = ddx( Input_UV145_g17 );
				float2 temp_output_12_0_g17 = ddy( Input_UV145_g17 );
				float4 Output_2D293_g17 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV12_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W12_g17 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV22_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W22_g17 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV32_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W32_g17 ) );
				float localStochasticTiling2_g2 = ( 0.0 );
				float2 uv_Splat1 = IN.ase_texcoord4.xy * _Splat1_ST.xy + _Splat1_ST.zw;
				float2 Input_UV145_g2 = uv_Splat1;
				float2 UV2_g2 = Input_UV145_g2;
				float2 UV12_g2 = float2( 0,0 );
				float2 UV22_g2 = float2( 0,0 );
				float2 UV32_g2 = float2( 0,0 );
				float W12_g2 = 0.0;
				float W22_g2 = 0.0;
				float W32_g2 = 0.0;
				StochasticTiling( UV2_g2 , UV12_g2 , UV22_g2 , UV32_g2 , W12_g2 , W22_g2 , W32_g2 );
				float2 temp_output_10_0_g2 = ddx( Input_UV145_g2 );
				float2 temp_output_12_0_g2 = ddy( Input_UV145_g2 );
				float4 Output_2D293_g2 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV12_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W12_g2 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV22_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W22_g2 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV32_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W32_g2 ) );
				float2 uv_Splatmaphehe = IN.ase_texcoord4.xy * _Splatmaphehe_ST.xy + _Splatmaphehe_ST.zw;
				float4 tex2DNode33 = SAMPLE_TEXTURE2D( _Splatmaphehe, sampler_Splatmaphehe, uv_Splatmaphehe );
				float Splat_R83 = tex2DNode33.r;
				float4 lerpResult45 = lerp( Output_2D293_g17 , Output_2D293_g2 , Splat_R83);
				float localStochasticTiling2_g3 = ( 0.0 );
				float2 uv_Splat2 = IN.ase_texcoord4.xy * _Splat2_ST.xy + _Splat2_ST.zw;
				float2 Input_UV145_g3 = uv_Splat2;
				float2 UV2_g3 = Input_UV145_g3;
				float2 UV12_g3 = float2( 0,0 );
				float2 UV22_g3 = float2( 0,0 );
				float2 UV32_g3 = float2( 0,0 );
				float W12_g3 = 0.0;
				float W22_g3 = 0.0;
				float W32_g3 = 0.0;
				StochasticTiling( UV2_g3 , UV12_g3 , UV22_g3 , UV32_g3 , W12_g3 , W22_g3 , W32_g3 );
				float2 temp_output_10_0_g3 = ddx( Input_UV145_g3 );
				float2 temp_output_12_0_g3 = ddy( Input_UV145_g3 );
				float4 Output_2D293_g3 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV12_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W12_g3 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV22_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W22_g3 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV32_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W32_g3 ) );
				float Splat_G84 = tex2DNode33.g;
				float4 lerpResult46 = lerp( lerpResult45 , Output_2D293_g3 , Splat_G84);
				float localStochasticTiling2_g4 = ( 0.0 );
				float2 uv_Splat3 = IN.ase_texcoord4.xy * _Splat3_ST.xy + _Splat3_ST.zw;
				float2 Input_UV145_g4 = uv_Splat3;
				float2 UV2_g4 = Input_UV145_g4;
				float2 UV12_g4 = float2( 0,0 );
				float2 UV22_g4 = float2( 0,0 );
				float2 UV32_g4 = float2( 0,0 );
				float W12_g4 = 0.0;
				float W22_g4 = 0.0;
				float W32_g4 = 0.0;
				StochasticTiling( UV2_g4 , UV12_g4 , UV22_g4 , UV32_g4 , W12_g4 , W22_g4 , W32_g4 );
				float2 temp_output_10_0_g4 = ddx( Input_UV145_g4 );
				float2 temp_output_12_0_g4 = ddy( Input_UV145_g4 );
				float4 Output_2D293_g4 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV12_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W12_g4 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV22_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W22_g4 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV32_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W32_g4 ) );
				float Splat_B85 = tex2DNode33.b;
				float4 lerpResult47 = lerp( lerpResult46 , Output_2D293_g4 , Splat_B85);
				float3 desaturateInitialColor49 = lerpResult47.rgb;
				float desaturateDot49 = dot( desaturateInitialColor49, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar49 = lerp( desaturateInitialColor49, desaturateDot49.xxx, 1.0 );
				float2 uv_Colormaphehe = IN.ase_texcoord4.xy * _Colormaphehe_ST.xy + _Colormaphehe_ST.zw;
				float4 tex2DNode10 = SAMPLE_TEXTURE2D( _Colormaphehe, sampler_Colormaphehe, uv_Colormaphehe );
				float grayscale167 = Luminance(tex2DNode10.rgb);
				float4 temp_cast_3 = (grayscale167).xxxx;
				float4 lerpResult168 = lerp( tex2DNode10 , temp_cast_3 , float4( 0.7924528,0.7924528,0.7924528,0 ));
				float4 temp_output_52_0 = ( ( float4( desaturateVar49 , 0.0 ) * lerpResult168 ) * 3.0 );
				float temp_output_199_0 = ( _TimeParameters.x * _AnimationSpeed );
				float2 appendResult177 = (float2(0.0 , ( temp_output_199_0 * 0.1 )));
				float2 texCoord174 = IN.ase_texcoord4.xy * ( _Noise_Emission_ST.xy * float2( 150,150 ) ) + appendResult177;
				float2 appendResult182 = (float2(( temp_output_199_0 * 0.2 ) , 0.0));
				float2 texCoord180 = IN.ase_texcoord4.xy * ( _Noise_Emission_ST.xy * float2( 100,100 ) ) + appendResult182;
				float2 appendResult193 = (float2(0.0 , ( temp_output_199_0 * 0.3 )));
				float2 texCoord192 = IN.ase_texcoord4.xy * ( _Noise_Emission_ST.xy * float2( 50,50 ) ) + appendResult193;
				float noisepath202 = ( ( ( ( SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord174 ).r * SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord180 ).r ) * SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord192 ).r ) * 10.0 ) + 0.1 );
				float2 uv_struggle_map = IN.ase_texcoord4.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D( _struggle_map, sampler_struggle_map, uv_struggle_map ).g );
				float temp_output_234_0 = saturate( temp_output_159_0 );
				float4 lerpResult162 = lerp( ( temp_output_52_0 * ( noisepath202 * _Emission ) ) , temp_output_52_0 , temp_output_234_0);
				float localStochasticTiling2_g19 = ( 0.0 );
				float2 Input_UV145_g19 = uv_Splat0;
				float2 UV2_g19 = Input_UV145_g19;
				float2 UV12_g19 = float2( 0,0 );
				float2 UV22_g19 = float2( 0,0 );
				float2 UV32_g19 = float2( 0,0 );
				float W12_g19 = 0.0;
				float W22_g19 = 0.0;
				float W32_g19 = 0.0;
				StochasticTiling( UV2_g19 , UV12_g19 , UV22_g19 , UV32_g19 , W12_g19 , W22_g19 , W32_g19 );
				float2 temp_output_10_0_g19 = ddx( Input_UV145_g19 );
				float2 temp_output_12_0_g19 = ddy( Input_UV145_g19 );
				float4 Output_2D293_g19 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV12_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W12_g19 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV22_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W22_g19 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV32_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W32_g19 ) );
				float3 unpack144 = UnpackNormalScale( Output_2D293_g19, _NormalScale0 );
				unpack144.z = lerp( 1, unpack144.z, saturate(_NormalScale0) );
				float localStochasticTiling2_g15 = ( 0.0 );
				float2 Input_UV145_g15 = uv_Splat1;
				float2 UV2_g15 = Input_UV145_g15;
				float2 UV12_g15 = float2( 0,0 );
				float2 UV22_g15 = float2( 0,0 );
				float2 UV32_g15 = float2( 0,0 );
				float W12_g15 = 0.0;
				float W22_g15 = 0.0;
				float W32_g15 = 0.0;
				StochasticTiling( UV2_g15 , UV12_g15 , UV22_g15 , UV32_g15 , W12_g15 , W22_g15 , W32_g15 );
				float2 temp_output_10_0_g15 = ddx( Input_UV145_g15 );
				float2 temp_output_12_0_g15 = ddy( Input_UV145_g15 );
				float4 Output_2D293_g15 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV12_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W12_g15 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV22_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W22_g15 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV32_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W32_g15 ) );
				float3 unpack147 = UnpackNormalScale( Output_2D293_g15, _NormalScale1 );
				unpack147.z = lerp( 1, unpack147.z, saturate(_NormalScale1) );
				float3 lerpResult98 = lerp( unpack144 , unpack147 , Splat_R83);
				float localStochasticTiling2_g16 = ( 0.0 );
				float2 uv_Normal2 = IN.ase_texcoord4.xy * _Normal2_ST.xy + _Normal2_ST.zw;
				float2 Input_UV145_g16 = uv_Normal2;
				float2 UV2_g16 = Input_UV145_g16;
				float2 UV12_g16 = float2( 0,0 );
				float2 UV22_g16 = float2( 0,0 );
				float2 UV32_g16 = float2( 0,0 );
				float W12_g16 = 0.0;
				float W22_g16 = 0.0;
				float W32_g16 = 0.0;
				StochasticTiling( UV2_g16 , UV12_g16 , UV22_g16 , UV32_g16 , W12_g16 , W22_g16 , W32_g16 );
				float2 temp_output_10_0_g16 = ddx( Input_UV145_g16 );
				float2 temp_output_12_0_g16 = ddy( Input_UV145_g16 );
				float4 Output_2D293_g16 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV12_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W12_g16 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV22_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W22_g16 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV32_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W32_g16 ) );
				float3 unpack149 = UnpackNormalScale( Output_2D293_g16, _NormalScale2 );
				unpack149.z = lerp( 1, unpack149.z, saturate(_NormalScale2) );
				float3 lerpResult99 = lerp( lerpResult98 , unpack149 , Splat_G84);
				float localStochasticTiling2_g18 = ( 0.0 );
				float2 Input_UV145_g18 = uv_Splat3;
				float2 UV2_g18 = Input_UV145_g18;
				float2 UV12_g18 = float2( 0,0 );
				float2 UV22_g18 = float2( 0,0 );
				float2 UV32_g18 = float2( 0,0 );
				float W12_g18 = 0.0;
				float W22_g18 = 0.0;
				float W32_g18 = 0.0;
				StochasticTiling( UV2_g18 , UV12_g18 , UV22_g18 , UV32_g18 , W12_g18 , W22_g18 , W32_g18 );
				float2 temp_output_10_0_g18 = ddx( Input_UV145_g18 );
				float2 temp_output_12_0_g18 = ddy( Input_UV145_g18 );
				float4 Output_2D293_g18 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV12_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W12_g18 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV22_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W22_g18 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV32_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W32_g18 ) );
				float3 unpack152 = UnpackNormalScale( Output_2D293_g18, _NormalScale3 );
				unpack152.z = lerp( 1, unpack152.z, saturate(_NormalScale3) );
				float3 lerpResult100 = lerp( lerpResult99 , unpack152 , Splat_B85);
				float3 temp_output_166_0 = ( lerpResult100 + temp_output_234_0 );
				float3 temp_output_245_0 = SHADERGRAPH_REFLECTION_PROBE(float3( 0,0,0 ),temp_output_166_0,0.0);
				

				float3 BaseColor = ( lerpResult162 + float4( ( temp_output_245_0 * float3( 0.1,0.1,0.1 ) ) , 0.0 ) ).rgb;
				float3 Emission = 0;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = BaseColor;
				metaInput.Emission = Emission;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = IN.VizUV.xy;
					metaInput.LightCoord = IN.LightCoord;
				#endif

				return UnityMetaFragment(metaInput);
			}
			ENDHLSL
		}

		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
	UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"

		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _struggle_map_ST;
			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splatmaphehe_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;
			float4 _Colormaphehe_ST;
			float4 _Noise_Emission_ST;
			float4 _Emission;
			float4 _Normal2_ST;
			float _Smoothness2;
			float _Smoothness1;
			float _Smoothness0;
			float _Metallic3;
			float _Metallic2;
			float _Metallic1;
			float _NormalScale1;
			float _NormalScale3;
			float _NormalScale2;
			float _Smoothness3;
			float _NormalScale0;
			float _AnimationSpeed;
			float _Metallic0;
			float _AmbiantOcclusion0;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_struggle_map);
			SAMPLER(sampler_struggle_map);
			TEXTURE2D(_Splat0);
			SAMPLER(sampler_Splat0);
			TEXTURE2D(_Splat1);
			SAMPLER(sampler_Splat1);
			TEXTURE2D(_Splatmaphehe);
			SAMPLER(sampler_Splatmaphehe);
			TEXTURE2D(_Splat2);
			SAMPLER(sampler_Splat2);
			TEXTURE2D(_Splat3);
			SAMPLER(sampler_Splat3);
			TEXTURE2D(_Colormaphehe);
			SAMPLER(sampler_Colormaphehe);
			TEXTURE2D(_Noise_Emission);
			SAMPLER(sampler_Noise_Emission);
			TEXTURE2D(_Normal0);
			SAMPLER(sampler_Normal0);
			TEXTURE2D(_Normal1);
			SAMPLER(sampler_Normal1);
			TEXTURE2D(_Normal2);
			SAMPLER(sampler_Normal2);
			TEXTURE2D(_Normal3);
			SAMPLER(sampler_Normal3);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			void StochasticTiling( float2 UV, out float2 UV1, out float2 UV2, out float2 UV3, out float W1, out float W2, out float W3 )
			{
				float2 vertex1, vertex2, vertex3;
				// Scaling of the input
				float2 uv = UV * 3.464; // 2 * sqrt (3)
				// Skew input space into simplex triangle grid
				const float2x2 gridToSkewedGrid = float2x2( 1.0, 0.0, -0.57735027, 1.15470054 );
				float2 skewedCoord = mul( gridToSkewedGrid, uv );
				// Compute local triangle vertex IDs and local barycentric coordinates
				int2 baseId = int2( floor( skewedCoord ) );
				float3 temp = float3( frac( skewedCoord ), 0 );
				temp.z = 1.0 - temp.x - temp.y;
				if ( temp.z > 0.0 )
				{
					W1 = temp.z;
					W2 = temp.y;
					W3 = temp.x;
					vertex1 = baseId;
					vertex2 = baseId + int2( 0, 1 );
					vertex3 = baseId + int2( 1, 0 );
				}
				else
				{
					W1 = -temp.z;
					W2 = 1.0 - temp.y;
					W3 = 1.0 - temp.x;
					vertex1 = baseId + int2( 1, 1 );
					vertex2 = baseId + int2( 1, 0 );
					vertex3 = baseId + int2( 0, 1 );
				}
				UV1 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex1 ) ) * 43758.5453 );
				UV2 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex2 ) ) * 43758.5453 );
				UV3 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex3 ) ) * 43758.5453 );
				return;
			}
			
			VertexInput ApplyMeshModification( VertexInput v )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				v.vertex.xz = sampleCoords* _TerrainHeightmapScale.xz;
				v.vertex.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					v.ase_normal = float3(0, 1, 0);
				#else
					v.ase_normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				v.ase_texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
				return v;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				v = ApplyMeshModification(v);
				float2 uv_struggle_map = v.ase_texcoord.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D_LOD( _struggle_map, sampler_struggle_map, uv_struggle_map, 0.0 ).g );
				float3 appendResult224 = (float3(0.0 , ( temp_output_159_0 * 0.0 ) , 0.0));
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = appendResult224;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float localStochasticTiling2_g17 = ( 0.0 );
				float2 uv_Splat0 = IN.ase_texcoord2.xy * _Splat0_ST.xy + _Splat0_ST.zw;
				float2 Input_UV145_g17 = uv_Splat0;
				float2 UV2_g17 = Input_UV145_g17;
				float2 UV12_g17 = float2( 0,0 );
				float2 UV22_g17 = float2( 0,0 );
				float2 UV32_g17 = float2( 0,0 );
				float W12_g17 = 0.0;
				float W22_g17 = 0.0;
				float W32_g17 = 0.0;
				StochasticTiling( UV2_g17 , UV12_g17 , UV22_g17 , UV32_g17 , W12_g17 , W22_g17 , W32_g17 );
				float2 temp_output_10_0_g17 = ddx( Input_UV145_g17 );
				float2 temp_output_12_0_g17 = ddy( Input_UV145_g17 );
				float4 Output_2D293_g17 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV12_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W12_g17 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV22_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W22_g17 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV32_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W32_g17 ) );
				float localStochasticTiling2_g2 = ( 0.0 );
				float2 uv_Splat1 = IN.ase_texcoord2.xy * _Splat1_ST.xy + _Splat1_ST.zw;
				float2 Input_UV145_g2 = uv_Splat1;
				float2 UV2_g2 = Input_UV145_g2;
				float2 UV12_g2 = float2( 0,0 );
				float2 UV22_g2 = float2( 0,0 );
				float2 UV32_g2 = float2( 0,0 );
				float W12_g2 = 0.0;
				float W22_g2 = 0.0;
				float W32_g2 = 0.0;
				StochasticTiling( UV2_g2 , UV12_g2 , UV22_g2 , UV32_g2 , W12_g2 , W22_g2 , W32_g2 );
				float2 temp_output_10_0_g2 = ddx( Input_UV145_g2 );
				float2 temp_output_12_0_g2 = ddy( Input_UV145_g2 );
				float4 Output_2D293_g2 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV12_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W12_g2 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV22_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W22_g2 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV32_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W32_g2 ) );
				float2 uv_Splatmaphehe = IN.ase_texcoord2.xy * _Splatmaphehe_ST.xy + _Splatmaphehe_ST.zw;
				float4 tex2DNode33 = SAMPLE_TEXTURE2D( _Splatmaphehe, sampler_Splatmaphehe, uv_Splatmaphehe );
				float Splat_R83 = tex2DNode33.r;
				float4 lerpResult45 = lerp( Output_2D293_g17 , Output_2D293_g2 , Splat_R83);
				float localStochasticTiling2_g3 = ( 0.0 );
				float2 uv_Splat2 = IN.ase_texcoord2.xy * _Splat2_ST.xy + _Splat2_ST.zw;
				float2 Input_UV145_g3 = uv_Splat2;
				float2 UV2_g3 = Input_UV145_g3;
				float2 UV12_g3 = float2( 0,0 );
				float2 UV22_g3 = float2( 0,0 );
				float2 UV32_g3 = float2( 0,0 );
				float W12_g3 = 0.0;
				float W22_g3 = 0.0;
				float W32_g3 = 0.0;
				StochasticTiling( UV2_g3 , UV12_g3 , UV22_g3 , UV32_g3 , W12_g3 , W22_g3 , W32_g3 );
				float2 temp_output_10_0_g3 = ddx( Input_UV145_g3 );
				float2 temp_output_12_0_g3 = ddy( Input_UV145_g3 );
				float4 Output_2D293_g3 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV12_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W12_g3 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV22_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W22_g3 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV32_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W32_g3 ) );
				float Splat_G84 = tex2DNode33.g;
				float4 lerpResult46 = lerp( lerpResult45 , Output_2D293_g3 , Splat_G84);
				float localStochasticTiling2_g4 = ( 0.0 );
				float2 uv_Splat3 = IN.ase_texcoord2.xy * _Splat3_ST.xy + _Splat3_ST.zw;
				float2 Input_UV145_g4 = uv_Splat3;
				float2 UV2_g4 = Input_UV145_g4;
				float2 UV12_g4 = float2( 0,0 );
				float2 UV22_g4 = float2( 0,0 );
				float2 UV32_g4 = float2( 0,0 );
				float W12_g4 = 0.0;
				float W22_g4 = 0.0;
				float W32_g4 = 0.0;
				StochasticTiling( UV2_g4 , UV12_g4 , UV22_g4 , UV32_g4 , W12_g4 , W22_g4 , W32_g4 );
				float2 temp_output_10_0_g4 = ddx( Input_UV145_g4 );
				float2 temp_output_12_0_g4 = ddy( Input_UV145_g4 );
				float4 Output_2D293_g4 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV12_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W12_g4 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV22_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W22_g4 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV32_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W32_g4 ) );
				float Splat_B85 = tex2DNode33.b;
				float4 lerpResult47 = lerp( lerpResult46 , Output_2D293_g4 , Splat_B85);
				float3 desaturateInitialColor49 = lerpResult47.rgb;
				float desaturateDot49 = dot( desaturateInitialColor49, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar49 = lerp( desaturateInitialColor49, desaturateDot49.xxx, 1.0 );
				float2 uv_Colormaphehe = IN.ase_texcoord2.xy * _Colormaphehe_ST.xy + _Colormaphehe_ST.zw;
				float4 tex2DNode10 = SAMPLE_TEXTURE2D( _Colormaphehe, sampler_Colormaphehe, uv_Colormaphehe );
				float grayscale167 = Luminance(tex2DNode10.rgb);
				float4 temp_cast_3 = (grayscale167).xxxx;
				float4 lerpResult168 = lerp( tex2DNode10 , temp_cast_3 , float4( 0.7924528,0.7924528,0.7924528,0 ));
				float4 temp_output_52_0 = ( ( float4( desaturateVar49 , 0.0 ) * lerpResult168 ) * 3.0 );
				float temp_output_199_0 = ( _TimeParameters.x * _AnimationSpeed );
				float2 appendResult177 = (float2(0.0 , ( temp_output_199_0 * 0.1 )));
				float2 texCoord174 = IN.ase_texcoord2.xy * ( _Noise_Emission_ST.xy * float2( 150,150 ) ) + appendResult177;
				float2 appendResult182 = (float2(( temp_output_199_0 * 0.2 ) , 0.0));
				float2 texCoord180 = IN.ase_texcoord2.xy * ( _Noise_Emission_ST.xy * float2( 100,100 ) ) + appendResult182;
				float2 appendResult193 = (float2(0.0 , ( temp_output_199_0 * 0.3 )));
				float2 texCoord192 = IN.ase_texcoord2.xy * ( _Noise_Emission_ST.xy * float2( 50,50 ) ) + appendResult193;
				float noisepath202 = ( ( ( ( SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord174 ).r * SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord180 ).r ) * SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord192 ).r ) * 10.0 ) + 0.1 );
				float2 uv_struggle_map = IN.ase_texcoord2.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D( _struggle_map, sampler_struggle_map, uv_struggle_map ).g );
				float temp_output_234_0 = saturate( temp_output_159_0 );
				float4 lerpResult162 = lerp( ( temp_output_52_0 * ( noisepath202 * _Emission ) ) , temp_output_52_0 , temp_output_234_0);
				float localStochasticTiling2_g19 = ( 0.0 );
				float2 Input_UV145_g19 = uv_Splat0;
				float2 UV2_g19 = Input_UV145_g19;
				float2 UV12_g19 = float2( 0,0 );
				float2 UV22_g19 = float2( 0,0 );
				float2 UV32_g19 = float2( 0,0 );
				float W12_g19 = 0.0;
				float W22_g19 = 0.0;
				float W32_g19 = 0.0;
				StochasticTiling( UV2_g19 , UV12_g19 , UV22_g19 , UV32_g19 , W12_g19 , W22_g19 , W32_g19 );
				float2 temp_output_10_0_g19 = ddx( Input_UV145_g19 );
				float2 temp_output_12_0_g19 = ddy( Input_UV145_g19 );
				float4 Output_2D293_g19 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV12_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W12_g19 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV22_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W22_g19 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV32_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W32_g19 ) );
				float3 unpack144 = UnpackNormalScale( Output_2D293_g19, _NormalScale0 );
				unpack144.z = lerp( 1, unpack144.z, saturate(_NormalScale0) );
				float localStochasticTiling2_g15 = ( 0.0 );
				float2 Input_UV145_g15 = uv_Splat1;
				float2 UV2_g15 = Input_UV145_g15;
				float2 UV12_g15 = float2( 0,0 );
				float2 UV22_g15 = float2( 0,0 );
				float2 UV32_g15 = float2( 0,0 );
				float W12_g15 = 0.0;
				float W22_g15 = 0.0;
				float W32_g15 = 0.0;
				StochasticTiling( UV2_g15 , UV12_g15 , UV22_g15 , UV32_g15 , W12_g15 , W22_g15 , W32_g15 );
				float2 temp_output_10_0_g15 = ddx( Input_UV145_g15 );
				float2 temp_output_12_0_g15 = ddy( Input_UV145_g15 );
				float4 Output_2D293_g15 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV12_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W12_g15 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV22_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W22_g15 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV32_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W32_g15 ) );
				float3 unpack147 = UnpackNormalScale( Output_2D293_g15, _NormalScale1 );
				unpack147.z = lerp( 1, unpack147.z, saturate(_NormalScale1) );
				float3 lerpResult98 = lerp( unpack144 , unpack147 , Splat_R83);
				float localStochasticTiling2_g16 = ( 0.0 );
				float2 uv_Normal2 = IN.ase_texcoord2.xy * _Normal2_ST.xy + _Normal2_ST.zw;
				float2 Input_UV145_g16 = uv_Normal2;
				float2 UV2_g16 = Input_UV145_g16;
				float2 UV12_g16 = float2( 0,0 );
				float2 UV22_g16 = float2( 0,0 );
				float2 UV32_g16 = float2( 0,0 );
				float W12_g16 = 0.0;
				float W22_g16 = 0.0;
				float W32_g16 = 0.0;
				StochasticTiling( UV2_g16 , UV12_g16 , UV22_g16 , UV32_g16 , W12_g16 , W22_g16 , W32_g16 );
				float2 temp_output_10_0_g16 = ddx( Input_UV145_g16 );
				float2 temp_output_12_0_g16 = ddy( Input_UV145_g16 );
				float4 Output_2D293_g16 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV12_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W12_g16 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV22_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W22_g16 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV32_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W32_g16 ) );
				float3 unpack149 = UnpackNormalScale( Output_2D293_g16, _NormalScale2 );
				unpack149.z = lerp( 1, unpack149.z, saturate(_NormalScale2) );
				float3 lerpResult99 = lerp( lerpResult98 , unpack149 , Splat_G84);
				float localStochasticTiling2_g18 = ( 0.0 );
				float2 Input_UV145_g18 = uv_Splat3;
				float2 UV2_g18 = Input_UV145_g18;
				float2 UV12_g18 = float2( 0,0 );
				float2 UV22_g18 = float2( 0,0 );
				float2 UV32_g18 = float2( 0,0 );
				float W12_g18 = 0.0;
				float W22_g18 = 0.0;
				float W32_g18 = 0.0;
				StochasticTiling( UV2_g18 , UV12_g18 , UV22_g18 , UV32_g18 , W12_g18 , W22_g18 , W32_g18 );
				float2 temp_output_10_0_g18 = ddx( Input_UV145_g18 );
				float2 temp_output_12_0_g18 = ddy( Input_UV145_g18 );
				float4 Output_2D293_g18 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV12_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W12_g18 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV22_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W22_g18 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV32_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W32_g18 ) );
				float3 unpack152 = UnpackNormalScale( Output_2D293_g18, _NormalScale3 );
				unpack152.z = lerp( 1, unpack152.z, saturate(_NormalScale3) );
				float3 lerpResult100 = lerp( lerpResult99 , unpack152 , Splat_B85);
				float3 temp_output_166_0 = ( lerpResult100 + temp_output_234_0 );
				float3 temp_output_245_0 = SHADERGRAPH_REFLECTION_PROBE(float3( 0,0,0 ),temp_output_166_0,0.0);
				

				float3 BaseColor = ( lerpResult162 + float4( ( temp_output_245_0 * float3( 0.1,0.1,0.1 ) ) , 0.0 ) ).rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				half4 color = half4(BaseColor, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}

		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
	UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"

		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormals" }

			ZWrite On
			Blend One Zero
			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float4 worldTangent : TEXCOORD2;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD3;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD4;
				#endif
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _struggle_map_ST;
			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splatmaphehe_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;
			float4 _Colormaphehe_ST;
			float4 _Noise_Emission_ST;
			float4 _Emission;
			float4 _Normal2_ST;
			float _Smoothness2;
			float _Smoothness1;
			float _Smoothness0;
			float _Metallic3;
			float _Metallic2;
			float _Metallic1;
			float _NormalScale1;
			float _NormalScale3;
			float _NormalScale2;
			float _Smoothness3;
			float _NormalScale0;
			float _AnimationSpeed;
			float _Metallic0;
			float _AmbiantOcclusion0;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_struggle_map);
			SAMPLER(sampler_struggle_map);
			TEXTURE2D(_Normal0);
			TEXTURE2D(_Splat0);
			SAMPLER(sampler_Normal0);
			TEXTURE2D(_Normal1);
			TEXTURE2D(_Splat1);
			SAMPLER(sampler_Normal1);
			TEXTURE2D(_Splatmaphehe);
			SAMPLER(sampler_Splatmaphehe);
			TEXTURE2D(_Normal2);
			SAMPLER(sampler_Normal2);
			TEXTURE2D(_Normal3);
			TEXTURE2D(_Splat3);
			SAMPLER(sampler_Normal3);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			void StochasticTiling( float2 UV, out float2 UV1, out float2 UV2, out float2 UV3, out float W1, out float W2, out float W3 )
			{
				float2 vertex1, vertex2, vertex3;
				// Scaling of the input
				float2 uv = UV * 3.464; // 2 * sqrt (3)
				// Skew input space into simplex triangle grid
				const float2x2 gridToSkewedGrid = float2x2( 1.0, 0.0, -0.57735027, 1.15470054 );
				float2 skewedCoord = mul( gridToSkewedGrid, uv );
				// Compute local triangle vertex IDs and local barycentric coordinates
				int2 baseId = int2( floor( skewedCoord ) );
				float3 temp = float3( frac( skewedCoord ), 0 );
				temp.z = 1.0 - temp.x - temp.y;
				if ( temp.z > 0.0 )
				{
					W1 = temp.z;
					W2 = temp.y;
					W3 = temp.x;
					vertex1 = baseId;
					vertex2 = baseId + int2( 0, 1 );
					vertex3 = baseId + int2( 1, 0 );
				}
				else
				{
					W1 = -temp.z;
					W2 = 1.0 - temp.y;
					W3 = 1.0 - temp.x;
					vertex1 = baseId + int2( 1, 1 );
					vertex2 = baseId + int2( 1, 0 );
					vertex3 = baseId + int2( 0, 1 );
				}
				UV1 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex1 ) ) * 43758.5453 );
				UV2 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex2 ) ) * 43758.5453 );
				UV3 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex3 ) ) * 43758.5453 );
				return;
			}
			
			VertexInput ApplyMeshModification( VertexInput v )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				v.vertex.xz = sampleCoords* _TerrainHeightmapScale.xz;
				v.vertex.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					v.ase_normal = float3(0, 1, 0);
				#else
					v.ase_normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				v.ase_texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
				return v;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				v = ApplyMeshModification(v);
				float2 uv_struggle_map = v.ase_texcoord.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D_LOD( _struggle_map, sampler_struggle_map, uv_struggle_map, 0.0 ).g );
				float3 appendResult224 = (float3(0.0 , ( temp_output_159_0 * 0.0 ) , 0.0));
				
				o.ase_texcoord5.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = appendResult224;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 normalWS = TransformObjectToWorldNormal( v.ase_normal );
				float4 tangentWS = float4(TransformObjectToWorldDir( v.ase_tangent.xyz), v.ase_tangent.w);
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.worldNormal = normalWS;
				o.worldTangent = tangentWS;

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			void frag(	VertexOutput IN
						, out half4 outNormalWS : SV_Target0
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float3 WorldNormal = IN.worldNormal;
				float4 WorldTangent = IN.worldTangent;

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float localStochasticTiling2_g19 = ( 0.0 );
				float2 uv_Splat0 = IN.ase_texcoord5.xy * _Splat0_ST.xy + _Splat0_ST.zw;
				float2 Input_UV145_g19 = uv_Splat0;
				float2 UV2_g19 = Input_UV145_g19;
				float2 UV12_g19 = float2( 0,0 );
				float2 UV22_g19 = float2( 0,0 );
				float2 UV32_g19 = float2( 0,0 );
				float W12_g19 = 0.0;
				float W22_g19 = 0.0;
				float W32_g19 = 0.0;
				StochasticTiling( UV2_g19 , UV12_g19 , UV22_g19 , UV32_g19 , W12_g19 , W22_g19 , W32_g19 );
				float2 temp_output_10_0_g19 = ddx( Input_UV145_g19 );
				float2 temp_output_12_0_g19 = ddy( Input_UV145_g19 );
				float4 Output_2D293_g19 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV12_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W12_g19 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV22_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W22_g19 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV32_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W32_g19 ) );
				float3 unpack144 = UnpackNormalScale( Output_2D293_g19, _NormalScale0 );
				unpack144.z = lerp( 1, unpack144.z, saturate(_NormalScale0) );
				float localStochasticTiling2_g15 = ( 0.0 );
				float2 uv_Splat1 = IN.ase_texcoord5.xy * _Splat1_ST.xy + _Splat1_ST.zw;
				float2 Input_UV145_g15 = uv_Splat1;
				float2 UV2_g15 = Input_UV145_g15;
				float2 UV12_g15 = float2( 0,0 );
				float2 UV22_g15 = float2( 0,0 );
				float2 UV32_g15 = float2( 0,0 );
				float W12_g15 = 0.0;
				float W22_g15 = 0.0;
				float W32_g15 = 0.0;
				StochasticTiling( UV2_g15 , UV12_g15 , UV22_g15 , UV32_g15 , W12_g15 , W22_g15 , W32_g15 );
				float2 temp_output_10_0_g15 = ddx( Input_UV145_g15 );
				float2 temp_output_12_0_g15 = ddy( Input_UV145_g15 );
				float4 Output_2D293_g15 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV12_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W12_g15 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV22_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W22_g15 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV32_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W32_g15 ) );
				float3 unpack147 = UnpackNormalScale( Output_2D293_g15, _NormalScale1 );
				unpack147.z = lerp( 1, unpack147.z, saturate(_NormalScale1) );
				float2 uv_Splatmaphehe = IN.ase_texcoord5.xy * _Splatmaphehe_ST.xy + _Splatmaphehe_ST.zw;
				float4 tex2DNode33 = SAMPLE_TEXTURE2D( _Splatmaphehe, sampler_Splatmaphehe, uv_Splatmaphehe );
				float Splat_R83 = tex2DNode33.r;
				float3 lerpResult98 = lerp( unpack144 , unpack147 , Splat_R83);
				float localStochasticTiling2_g16 = ( 0.0 );
				float2 uv_Normal2 = IN.ase_texcoord5.xy * _Normal2_ST.xy + _Normal2_ST.zw;
				float2 Input_UV145_g16 = uv_Normal2;
				float2 UV2_g16 = Input_UV145_g16;
				float2 UV12_g16 = float2( 0,0 );
				float2 UV22_g16 = float2( 0,0 );
				float2 UV32_g16 = float2( 0,0 );
				float W12_g16 = 0.0;
				float W22_g16 = 0.0;
				float W32_g16 = 0.0;
				StochasticTiling( UV2_g16 , UV12_g16 , UV22_g16 , UV32_g16 , W12_g16 , W22_g16 , W32_g16 );
				float2 temp_output_10_0_g16 = ddx( Input_UV145_g16 );
				float2 temp_output_12_0_g16 = ddy( Input_UV145_g16 );
				float4 Output_2D293_g16 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV12_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W12_g16 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV22_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W22_g16 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV32_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W32_g16 ) );
				float3 unpack149 = UnpackNormalScale( Output_2D293_g16, _NormalScale2 );
				unpack149.z = lerp( 1, unpack149.z, saturate(_NormalScale2) );
				float Splat_G84 = tex2DNode33.g;
				float3 lerpResult99 = lerp( lerpResult98 , unpack149 , Splat_G84);
				float localStochasticTiling2_g18 = ( 0.0 );
				float2 uv_Splat3 = IN.ase_texcoord5.xy * _Splat3_ST.xy + _Splat3_ST.zw;
				float2 Input_UV145_g18 = uv_Splat3;
				float2 UV2_g18 = Input_UV145_g18;
				float2 UV12_g18 = float2( 0,0 );
				float2 UV22_g18 = float2( 0,0 );
				float2 UV32_g18 = float2( 0,0 );
				float W12_g18 = 0.0;
				float W22_g18 = 0.0;
				float W32_g18 = 0.0;
				StochasticTiling( UV2_g18 , UV12_g18 , UV22_g18 , UV32_g18 , W12_g18 , W22_g18 , W32_g18 );
				float2 temp_output_10_0_g18 = ddx( Input_UV145_g18 );
				float2 temp_output_12_0_g18 = ddy( Input_UV145_g18 );
				float4 Output_2D293_g18 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV12_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W12_g18 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV22_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W22_g18 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV32_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W32_g18 ) );
				float3 unpack152 = UnpackNormalScale( Output_2D293_g18, _NormalScale3 );
				unpack152.z = lerp( 1, unpack152.z, saturate(_NormalScale3) );
				float Splat_B85 = tex2DNode33.b;
				float3 lerpResult100 = lerp( lerpResult99 , unpack152 , Splat_B85);
				float2 uv_struggle_map = IN.ase_texcoord5.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D( _struggle_map, sampler_struggle_map, uv_struggle_map ).g );
				float temp_output_234_0 = saturate( temp_output_159_0 );
				float3 temp_output_166_0 = ( lerpResult100 + temp_output_234_0 );
				

				float3 Normal = temp_output_166_0;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(WorldNormal);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					outNormalWS = half4(packedNormalWS, 0.0);
				#else
					#if defined(_NORMALMAP)
						#if _NORMAL_DROPOFF_TS
							float crossSign = (WorldTangent.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
							float3 bitangent = crossSign * cross(WorldNormal.xyz, WorldTangent.xyz);
							float3 normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent.xyz, bitangent, WorldNormal.xyz));
						#elif _NORMAL_DROPOFF_OS
							float3 normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							float3 normalWS = Normal;
						#endif
					#else
						float3 normalWS = WorldNormal;
					#endif
					outNormalWS = half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
				#endif
			}
			ENDHLSL
		}

		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
	UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"

		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="UniversalGBuffer" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#pragma instancing_options renderinglayer
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_GBUFFER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif
			
			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				ASE_SV_POSITION_QUALIFIERS float4 clipPos : SV_POSITION;
				float4 clipPosV : TEXCOORD0;
				float4 lightmapUVOrVertexSH : TEXCOORD1;
				half4 fogFactorAndVertexLight : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
				float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _struggle_map_ST;
			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splatmaphehe_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;
			float4 _Colormaphehe_ST;
			float4 _Noise_Emission_ST;
			float4 _Emission;
			float4 _Normal2_ST;
			float _Smoothness2;
			float _Smoothness1;
			float _Smoothness0;
			float _Metallic3;
			float _Metallic2;
			float _Metallic1;
			float _NormalScale1;
			float _NormalScale3;
			float _NormalScale2;
			float _Smoothness3;
			float _NormalScale0;
			float _AnimationSpeed;
			float _Metallic0;
			float _AmbiantOcclusion0;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_struggle_map);
			SAMPLER(sampler_struggle_map);
			TEXTURE2D(_Splat0);
			SAMPLER(sampler_Splat0);
			TEXTURE2D(_Splat1);
			SAMPLER(sampler_Splat1);
			TEXTURE2D(_Splatmaphehe);
			SAMPLER(sampler_Splatmaphehe);
			TEXTURE2D(_Splat2);
			SAMPLER(sampler_Splat2);
			TEXTURE2D(_Splat3);
			SAMPLER(sampler_Splat3);
			TEXTURE2D(_Colormaphehe);
			SAMPLER(sampler_Colormaphehe);
			TEXTURE2D(_Noise_Emission);
			SAMPLER(sampler_Noise_Emission);
			TEXTURE2D(_Normal0);
			SAMPLER(sampler_Normal0);
			TEXTURE2D(_Normal1);
			SAMPLER(sampler_Normal1);
			TEXTURE2D(_Normal2);
			SAMPLER(sampler_Normal2);
			TEXTURE2D(_Normal3);
			SAMPLER(sampler_Normal3);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"

			void StochasticTiling( float2 UV, out float2 UV1, out float2 UV2, out float2 UV3, out float W1, out float W2, out float W3 )
			{
				float2 vertex1, vertex2, vertex3;
				// Scaling of the input
				float2 uv = UV * 3.464; // 2 * sqrt (3)
				// Skew input space into simplex triangle grid
				const float2x2 gridToSkewedGrid = float2x2( 1.0, 0.0, -0.57735027, 1.15470054 );
				float2 skewedCoord = mul( gridToSkewedGrid, uv );
				// Compute local triangle vertex IDs and local barycentric coordinates
				int2 baseId = int2( floor( skewedCoord ) );
				float3 temp = float3( frac( skewedCoord ), 0 );
				temp.z = 1.0 - temp.x - temp.y;
				if ( temp.z > 0.0 )
				{
					W1 = temp.z;
					W2 = temp.y;
					W3 = temp.x;
					vertex1 = baseId;
					vertex2 = baseId + int2( 0, 1 );
					vertex3 = baseId + int2( 1, 0 );
				}
				else
				{
					W1 = -temp.z;
					W2 = 1.0 - temp.y;
					W3 = 1.0 - temp.x;
					vertex1 = baseId + int2( 1, 1 );
					vertex2 = baseId + int2( 1, 0 );
					vertex3 = baseId + int2( 0, 1 );
				}
				UV1 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex1 ) ) * 43758.5453 );
				UV2 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex2 ) ) * 43758.5453 );
				UV3 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex3 ) ) * 43758.5453 );
				return;
			}
			
			VertexInput ApplyMeshModification( VertexInput v )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				v.vertex.xz = sampleCoords* _TerrainHeightmapScale.xz;
				v.vertex.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					v.ase_normal = float3(0, 1, 0);
				#else
					v.ase_normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				v.texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
				return v;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				v = ApplyMeshModification(v);
				float2 uv_struggle_map = v.texcoord.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D_LOD( _struggle_map, sampler_struggle_map, uv_struggle_map, 0.0 ).g );
				float3 appendResult224 = (float3(0.0 , ( temp_output_159_0 * 0.0 ) , 0.0));
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = appendResult224;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH(normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz);
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord.xy;
					o.lightmapUVOrVertexSH.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				o.fogFactorAndVertexLight = half4(0, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				o.clipPosV = positionCS;
				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			FragmentOutput frag ( VertexOutput IN
								#ifdef ASE_DEPTH_WRITE_ON
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				float4 ClipPos = IN.clipPosV;
				float4 ScreenPos = ComputeScreenPos( IN.clipPosV );

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#else
					ShadowCoords = float4(0, 0, 0, 0);
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float localStochasticTiling2_g17 = ( 0.0 );
				float2 uv_Splat0 = IN.ase_texcoord8.xy * _Splat0_ST.xy + _Splat0_ST.zw;
				float2 Input_UV145_g17 = uv_Splat0;
				float2 UV2_g17 = Input_UV145_g17;
				float2 UV12_g17 = float2( 0,0 );
				float2 UV22_g17 = float2( 0,0 );
				float2 UV32_g17 = float2( 0,0 );
				float W12_g17 = 0.0;
				float W22_g17 = 0.0;
				float W32_g17 = 0.0;
				StochasticTiling( UV2_g17 , UV12_g17 , UV22_g17 , UV32_g17 , W12_g17 , W22_g17 , W32_g17 );
				float2 temp_output_10_0_g17 = ddx( Input_UV145_g17 );
				float2 temp_output_12_0_g17 = ddy( Input_UV145_g17 );
				float4 Output_2D293_g17 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV12_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W12_g17 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV22_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W22_g17 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat0, sampler_Splat0, UV32_g17, temp_output_10_0_g17, temp_output_12_0_g17 ) * W32_g17 ) );
				float localStochasticTiling2_g2 = ( 0.0 );
				float2 uv_Splat1 = IN.ase_texcoord8.xy * _Splat1_ST.xy + _Splat1_ST.zw;
				float2 Input_UV145_g2 = uv_Splat1;
				float2 UV2_g2 = Input_UV145_g2;
				float2 UV12_g2 = float2( 0,0 );
				float2 UV22_g2 = float2( 0,0 );
				float2 UV32_g2 = float2( 0,0 );
				float W12_g2 = 0.0;
				float W22_g2 = 0.0;
				float W32_g2 = 0.0;
				StochasticTiling( UV2_g2 , UV12_g2 , UV22_g2 , UV32_g2 , W12_g2 , W22_g2 , W32_g2 );
				float2 temp_output_10_0_g2 = ddx( Input_UV145_g2 );
				float2 temp_output_12_0_g2 = ddy( Input_UV145_g2 );
				float4 Output_2D293_g2 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV12_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W12_g2 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV22_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W22_g2 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat1, sampler_Splat1, UV32_g2, temp_output_10_0_g2, temp_output_12_0_g2 ) * W32_g2 ) );
				float2 uv_Splatmaphehe = IN.ase_texcoord8.xy * _Splatmaphehe_ST.xy + _Splatmaphehe_ST.zw;
				float4 tex2DNode33 = SAMPLE_TEXTURE2D( _Splatmaphehe, sampler_Splatmaphehe, uv_Splatmaphehe );
				float Splat_R83 = tex2DNode33.r;
				float4 lerpResult45 = lerp( Output_2D293_g17 , Output_2D293_g2 , Splat_R83);
				float localStochasticTiling2_g3 = ( 0.0 );
				float2 uv_Splat2 = IN.ase_texcoord8.xy * _Splat2_ST.xy + _Splat2_ST.zw;
				float2 Input_UV145_g3 = uv_Splat2;
				float2 UV2_g3 = Input_UV145_g3;
				float2 UV12_g3 = float2( 0,0 );
				float2 UV22_g3 = float2( 0,0 );
				float2 UV32_g3 = float2( 0,0 );
				float W12_g3 = 0.0;
				float W22_g3 = 0.0;
				float W32_g3 = 0.0;
				StochasticTiling( UV2_g3 , UV12_g3 , UV22_g3 , UV32_g3 , W12_g3 , W22_g3 , W32_g3 );
				float2 temp_output_10_0_g3 = ddx( Input_UV145_g3 );
				float2 temp_output_12_0_g3 = ddy( Input_UV145_g3 );
				float4 Output_2D293_g3 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV12_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W12_g3 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV22_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W22_g3 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat2, sampler_Splat2, UV32_g3, temp_output_10_0_g3, temp_output_12_0_g3 ) * W32_g3 ) );
				float Splat_G84 = tex2DNode33.g;
				float4 lerpResult46 = lerp( lerpResult45 , Output_2D293_g3 , Splat_G84);
				float localStochasticTiling2_g4 = ( 0.0 );
				float2 uv_Splat3 = IN.ase_texcoord8.xy * _Splat3_ST.xy + _Splat3_ST.zw;
				float2 Input_UV145_g4 = uv_Splat3;
				float2 UV2_g4 = Input_UV145_g4;
				float2 UV12_g4 = float2( 0,0 );
				float2 UV22_g4 = float2( 0,0 );
				float2 UV32_g4 = float2( 0,0 );
				float W12_g4 = 0.0;
				float W22_g4 = 0.0;
				float W32_g4 = 0.0;
				StochasticTiling( UV2_g4 , UV12_g4 , UV22_g4 , UV32_g4 , W12_g4 , W22_g4 , W32_g4 );
				float2 temp_output_10_0_g4 = ddx( Input_UV145_g4 );
				float2 temp_output_12_0_g4 = ddy( Input_UV145_g4 );
				float4 Output_2D293_g4 = ( ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV12_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W12_g4 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV22_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W22_g4 ) + ( SAMPLE_TEXTURE2D_GRAD( _Splat3, sampler_Splat3, UV32_g4, temp_output_10_0_g4, temp_output_12_0_g4 ) * W32_g4 ) );
				float Splat_B85 = tex2DNode33.b;
				float4 lerpResult47 = lerp( lerpResult46 , Output_2D293_g4 , Splat_B85);
				float3 desaturateInitialColor49 = lerpResult47.rgb;
				float desaturateDot49 = dot( desaturateInitialColor49, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar49 = lerp( desaturateInitialColor49, desaturateDot49.xxx, 1.0 );
				float2 uv_Colormaphehe = IN.ase_texcoord8.xy * _Colormaphehe_ST.xy + _Colormaphehe_ST.zw;
				float4 tex2DNode10 = SAMPLE_TEXTURE2D( _Colormaphehe, sampler_Colormaphehe, uv_Colormaphehe );
				float grayscale167 = Luminance(tex2DNode10.rgb);
				float4 temp_cast_3 = (grayscale167).xxxx;
				float4 lerpResult168 = lerp( tex2DNode10 , temp_cast_3 , float4( 0.7924528,0.7924528,0.7924528,0 ));
				float4 temp_output_52_0 = ( ( float4( desaturateVar49 , 0.0 ) * lerpResult168 ) * 3.0 );
				float temp_output_199_0 = ( _TimeParameters.x * _AnimationSpeed );
				float2 appendResult177 = (float2(0.0 , ( temp_output_199_0 * 0.1 )));
				float2 texCoord174 = IN.ase_texcoord8.xy * ( _Noise_Emission_ST.xy * float2( 150,150 ) ) + appendResult177;
				float2 appendResult182 = (float2(( temp_output_199_0 * 0.2 ) , 0.0));
				float2 texCoord180 = IN.ase_texcoord8.xy * ( _Noise_Emission_ST.xy * float2( 100,100 ) ) + appendResult182;
				float2 appendResult193 = (float2(0.0 , ( temp_output_199_0 * 0.3 )));
				float2 texCoord192 = IN.ase_texcoord8.xy * ( _Noise_Emission_ST.xy * float2( 50,50 ) ) + appendResult193;
				float noisepath202 = ( ( ( ( SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord174 ).r * SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord180 ).r ) * SAMPLE_TEXTURE2D( _Noise_Emission, sampler_Noise_Emission, texCoord192 ).r ) * 10.0 ) + 0.1 );
				float2 uv_struggle_map = IN.ase_texcoord8.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D( _struggle_map, sampler_struggle_map, uv_struggle_map ).g );
				float temp_output_234_0 = saturate( temp_output_159_0 );
				float4 lerpResult162 = lerp( ( temp_output_52_0 * ( noisepath202 * _Emission ) ) , temp_output_52_0 , temp_output_234_0);
				float localStochasticTiling2_g19 = ( 0.0 );
				float2 Input_UV145_g19 = uv_Splat0;
				float2 UV2_g19 = Input_UV145_g19;
				float2 UV12_g19 = float2( 0,0 );
				float2 UV22_g19 = float2( 0,0 );
				float2 UV32_g19 = float2( 0,0 );
				float W12_g19 = 0.0;
				float W22_g19 = 0.0;
				float W32_g19 = 0.0;
				StochasticTiling( UV2_g19 , UV12_g19 , UV22_g19 , UV32_g19 , W12_g19 , W22_g19 , W32_g19 );
				float2 temp_output_10_0_g19 = ddx( Input_UV145_g19 );
				float2 temp_output_12_0_g19 = ddy( Input_UV145_g19 );
				float4 Output_2D293_g19 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV12_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W12_g19 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV22_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W22_g19 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal0, sampler_Normal0, UV32_g19, temp_output_10_0_g19, temp_output_12_0_g19 ) * W32_g19 ) );
				float3 unpack144 = UnpackNormalScale( Output_2D293_g19, _NormalScale0 );
				unpack144.z = lerp( 1, unpack144.z, saturate(_NormalScale0) );
				float localStochasticTiling2_g15 = ( 0.0 );
				float2 Input_UV145_g15 = uv_Splat1;
				float2 UV2_g15 = Input_UV145_g15;
				float2 UV12_g15 = float2( 0,0 );
				float2 UV22_g15 = float2( 0,0 );
				float2 UV32_g15 = float2( 0,0 );
				float W12_g15 = 0.0;
				float W22_g15 = 0.0;
				float W32_g15 = 0.0;
				StochasticTiling( UV2_g15 , UV12_g15 , UV22_g15 , UV32_g15 , W12_g15 , W22_g15 , W32_g15 );
				float2 temp_output_10_0_g15 = ddx( Input_UV145_g15 );
				float2 temp_output_12_0_g15 = ddy( Input_UV145_g15 );
				float4 Output_2D293_g15 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV12_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W12_g15 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV22_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W22_g15 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal1, sampler_Normal1, UV32_g15, temp_output_10_0_g15, temp_output_12_0_g15 ) * W32_g15 ) );
				float3 unpack147 = UnpackNormalScale( Output_2D293_g15, _NormalScale1 );
				unpack147.z = lerp( 1, unpack147.z, saturate(_NormalScale1) );
				float3 lerpResult98 = lerp( unpack144 , unpack147 , Splat_R83);
				float localStochasticTiling2_g16 = ( 0.0 );
				float2 uv_Normal2 = IN.ase_texcoord8.xy * _Normal2_ST.xy + _Normal2_ST.zw;
				float2 Input_UV145_g16 = uv_Normal2;
				float2 UV2_g16 = Input_UV145_g16;
				float2 UV12_g16 = float2( 0,0 );
				float2 UV22_g16 = float2( 0,0 );
				float2 UV32_g16 = float2( 0,0 );
				float W12_g16 = 0.0;
				float W22_g16 = 0.0;
				float W32_g16 = 0.0;
				StochasticTiling( UV2_g16 , UV12_g16 , UV22_g16 , UV32_g16 , W12_g16 , W22_g16 , W32_g16 );
				float2 temp_output_10_0_g16 = ddx( Input_UV145_g16 );
				float2 temp_output_12_0_g16 = ddy( Input_UV145_g16 );
				float4 Output_2D293_g16 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV12_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W12_g16 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV22_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W22_g16 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal2, sampler_Normal2, UV32_g16, temp_output_10_0_g16, temp_output_12_0_g16 ) * W32_g16 ) );
				float3 unpack149 = UnpackNormalScale( Output_2D293_g16, _NormalScale2 );
				unpack149.z = lerp( 1, unpack149.z, saturate(_NormalScale2) );
				float3 lerpResult99 = lerp( lerpResult98 , unpack149 , Splat_G84);
				float localStochasticTiling2_g18 = ( 0.0 );
				float2 Input_UV145_g18 = uv_Splat3;
				float2 UV2_g18 = Input_UV145_g18;
				float2 UV12_g18 = float2( 0,0 );
				float2 UV22_g18 = float2( 0,0 );
				float2 UV32_g18 = float2( 0,0 );
				float W12_g18 = 0.0;
				float W22_g18 = 0.0;
				float W32_g18 = 0.0;
				StochasticTiling( UV2_g18 , UV12_g18 , UV22_g18 , UV32_g18 , W12_g18 , W22_g18 , W32_g18 );
				float2 temp_output_10_0_g18 = ddx( Input_UV145_g18 );
				float2 temp_output_12_0_g18 = ddy( Input_UV145_g18 );
				float4 Output_2D293_g18 = ( ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV12_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W12_g18 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV22_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W22_g18 ) + ( SAMPLE_TEXTURE2D_GRAD( _Normal3, sampler_Normal3, UV32_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W32_g18 ) );
				float3 unpack152 = UnpackNormalScale( Output_2D293_g18, _NormalScale3 );
				unpack152.z = lerp( 1, unpack152.z, saturate(_NormalScale3) );
				float3 lerpResult100 = lerp( lerpResult99 , unpack152 , Splat_B85);
				float3 temp_output_166_0 = ( lerpResult100 + temp_output_234_0 );
				float3 temp_output_245_0 = SHADERGRAPH_REFLECTION_PROBE(float3( 0,0,0 ),temp_output_166_0,0.0);
				
				float lerpResult128 = lerp( _Metallic0 , _Metallic1 , Splat_R83);
				float lerpResult131 = lerp( lerpResult128 , _Metallic2 , Splat_G84);
				float lerpResult133 = lerp( lerpResult131 , _Metallic3 , Splat_B85);
				
				float lerpResult119 = lerp( _Smoothness0 , _Smoothness1 , Splat_R83);
				float lerpResult122 = lerp( lerpResult119 , _Smoothness2 , Splat_G84);
				float lerpResult124 = lerp( lerpResult122 , _Smoothness3 , Splat_B85);
				

				float3 BaseColor = ( lerpResult162 + float4( ( temp_output_245_0 * float3( 0.1,0.1,0.1 ) ) , 0.0 ) ).rgb;
				float3 Normal = temp_output_166_0;
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = lerpResult133;
				float Smoothness = lerpResult124;
				float Occlusion = _AmbiantOcclusion0;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = IN.clipPos.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.positionCS = IN.clipPos;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
						inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
						inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
						inputData.normalWS = Normal;
					#endif
				#else
					inputData.normalWS = WorldNormal;
				#endif

				inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				inputData.viewDirectionWS = SafeNormalize( WorldViewDirection );

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#else
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
					#else
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
						#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				#ifdef _DBUFFER
					ApplyDecal(IN.clipPos,
						BaseColor,
						Specular,
						inputData.normalWS,
						Metallic,
						Occlusion,
						Smoothness);
				#endif

				BRDFData brdfData;
				InitializeBRDFData
				(BaseColor, Metallic, Specular, Smoothness, Alpha, brdfData);

				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				half4 color;
				MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI, inputData.shadowMask);
				color.rgb = GlobalIllumination(brdfData, inputData.bakedGI, Occlusion, inputData.positionWS, inputData.normalWS, inputData.viewDirectionWS);
				color.a = Alpha;

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return BRDFDataToGbuffer(brdfData, inputData, Smoothness, Emission + color.rgb, Occlusion);
			}

			ENDHLSL
		}

		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
	UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"

		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			Cull Off
			AlphaToMask Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#define SCENESELECTIONPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _struggle_map_ST;
			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splatmaphehe_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;
			float4 _Colormaphehe_ST;
			float4 _Noise_Emission_ST;
			float4 _Emission;
			float4 _Normal2_ST;
			float _Smoothness2;
			float _Smoothness1;
			float _Smoothness0;
			float _Metallic3;
			float _Metallic2;
			float _Metallic1;
			float _NormalScale1;
			float _NormalScale3;
			float _NormalScale2;
			float _Smoothness3;
			float _NormalScale0;
			float _AnimationSpeed;
			float _Metallic0;
			float _AmbiantOcclusion0;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_struggle_map);
			SAMPLER(sampler_struggle_map);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			VertexInput ApplyMeshModification( VertexInput v )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				v.vertex.xz = sampleCoords* _TerrainHeightmapScale.xz;
				v.vertex.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					v.ase_normal = float3(0, 1, 0);
				#else
					v.ase_normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				v.ase_texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
				return v;
			}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				v = ApplyMeshModification(v);
				float2 uv_struggle_map = v.ase_texcoord.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D_LOD( _struggle_map, sampler_struggle_map, uv_struggle_map, 0.0 ).g );
				float3 appendResult224 = (float3(0.0 , ( temp_output_159_0 * 0.0 ) , 0.0));
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = appendResult224;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				o.clipPos = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				

				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}

		UsePass "Hidden/Nature/Terrain/Utilities/PICKING"
	UsePass "Hidden/Nature/Terrain/Utilities/SELECTION"

		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="Picking" }

			AlphaToMask Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140008
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

		    #define SCENEPICKINGPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _struggle_map_ST;
			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splatmaphehe_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;
			float4 _Colormaphehe_ST;
			float4 _Noise_Emission_ST;
			float4 _Emission;
			float4 _Normal2_ST;
			float _Smoothness2;
			float _Smoothness1;
			float _Smoothness0;
			float _Metallic3;
			float _Metallic2;
			float _Metallic1;
			float _NormalScale1;
			float _NormalScale3;
			float _NormalScale2;
			float _Smoothness3;
			float _NormalScale0;
			float _AnimationSpeed;
			float _Metallic0;
			float _AmbiantOcclusion0;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_struggle_map);
			SAMPLER(sampler_struggle_map);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
			#endif//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
				UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
			UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
			CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
					float4 _TerrainHeightmapScale;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
			CBUFFER_END//ASE Terrain Instancing


			VertexInput ApplyMeshModification( VertexInput v )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = v.vertex.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				v.vertex.xz = sampleCoords* _TerrainHeightmapScale.xz;
				v.vertex.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					v.ase_normal = float3(0, 1, 0);
				#else
					v.ase_normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				v.ase_texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
				return v;
			}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				v = ApplyMeshModification(v);
				float2 uv_struggle_map = v.ase_texcoord.xy * _struggle_map_ST.xy + _struggle_map_ST.zw;
				float temp_output_159_0 = ( 1.0 - SAMPLE_TEXTURE2D_LOD( _struggle_map, sampler_struggle_map, uv_struggle_map, 0.0 ).g );
				float3 appendResult224 = (float3(0.0 , ( temp_output_159_0 * 0.0 ) , 0.0));
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = appendResult224;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				o.clipPos = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				

				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
						clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}
		
	}
	
	CustomEditor "UnityEditor.ShaderGraphLitGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19201
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;True;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;6;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormals;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;7;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalGBuffer;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;8;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;9;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;2088.766,1323.179;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;256.5447,1307.616;Inherit;False;0;54;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;991.7152,2.782804;Inherit;False;Splat_R;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;994.7152,77.78309;Inherit;False;Splat_G;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;996.7152,152.783;Inherit;False;Splat_B;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;92;1060.897,-175.4057;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;59;587.0169,832.5229;Inherit;False;Procedural Sample;-1;;2;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.FunctionNode;60;579.8499,1208.467;Inherit;False;Procedural Sample;-1;;3;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;256.7115,934.6721;Inherit;False;0;57;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;55;560.1863,1522.867;Inherit;False;Procedural Sample;-1;;4;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;266.084,1676.338;Inherit;False;0;56;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;56;260.8501,1470.467;Inherit;True;Property;_Splat3;Splat3;12;1;[HideInInspector];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;54;261.4459,1119.419;Inherit;True;Property;_Splat2;Splat2;6;1;[HideInInspector];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;99;1334.548,2486.739;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;101;640.6304,2436.761;Inherit;False;Procedural Sample;-1;;15;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.FunctionNode;102;633.4634,2812.706;Inherit;False;Procedural Sample;-1;;16;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;104;934.5878,2430.406;Inherit;False;83;Splat_R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;967.5878,2595.406;Inherit;False;84;Splat_G;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;110;310.3248,2538.911;Inherit;False;0;57;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;108;285.9565,2341.68;Inherit;True;Property;_Normal1;Normal1;15;1;[HideInInspector];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;107;313.0592,2722.657;Inherit;True;Property;_Normal2;Normal2;7;1;[HideInInspector];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;114;304.6973,3197.231;Inherit;False;0;56;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;113;298.4634,2990.361;Inherit;True;Property;_Normal3;Normal3;13;1;[HideInInspector];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;61;666.1172,499.8231;Inherit;False;Procedural Sample;-1;;17;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.TexturePropertyNode;57;232.3432,737.4414;Inherit;True;Property;_Splat1;Splat1;14;1;[HideInInspector];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;112;633.988,3036.429;Inherit;False;Procedural Sample;-1;;18;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.LerpOp;45;1044.475,649.555;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;880.9744,826.1675;Inherit;False;83;Splat_R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;913.9744,991.1675;Inherit;False;84;Splat_G;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;1280.935,882.5005;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;1066.974,1217.167;Inherit;False;85;Splat_B;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;1437.935,1094.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;128;3074.912,1779.105;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;2911.412,1955.718;Inherit;False;83;Splat_R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;2944.412,2120.718;Inherit;False;84;Splat_G;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;131;3311.372,2012.052;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;3097.411,2346.718;Inherit;False;85;Splat_B;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;133;3468.372,2224.051;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;2278.167,1953.085;Float;False;Property;_Metallic1;Metallic1;22;2;[HideInInspector];[Gamma];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;2283.167,2051.084;Float;False;Property;_Metallic2;Metallic2;20;2;[HideInInspector];[Gamma];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;2294.167,2149.084;Float;False;Property;_Metallic3;Metallic3;21;2;[HideInInspector];[Gamma];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;100;1714.594,2726.512;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;1261.713,3062.148;Inherit;False;85;Splat_B;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;103;643.7306,2017.062;Inherit;False;Procedural Sample;-1;;19;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.LerpOp;98;1261.088,2259.793;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;144;984.7026,2027.109;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.UnpackScaleNormalNode;147;1016.185,2301.119;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;148;666.7631,2338.581;Inherit;False;Property;_NormalScale1;NormalScale1;8;1;[HideInInspector];Create;True;0;0;0;False;0;False;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;634.2806,2246.571;Inherit;False;Property;_NormalScale0;NormalScale0;9;1;[HideInInspector];Create;True;0;0;0;False;0;False;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;703.9645,2718.326;Inherit;False;Property;_NormalScale2;NormalScale2;11;1;[HideInInspector];Create;True;0;0;0;False;0;False;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;149;1053.386,2680.864;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.UnpackScaleNormalNode;152;1173.386,2895.865;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;151;836.9645,3208.326;Inherit;False;Property;_NormalScale3;NormalScale2;10;1;[HideInInspector];Create;True;0;0;0;False;0;False;2.5;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;2276.499,1864.236;Float;False;Property;_Metallic0;Metallic0;18;2;[HideInInspector];[Gamma];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;58;246.9815,394.1943;Inherit;True;Property;_Splat0;Splat0;16;1;[HideInInspector];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;111;300.5948,1998.433;Inherit;True;Property;_Normal0;Normal0;17;1;[HideInInspector];Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;1885.779,1318.024;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;53;1754.766,1469.179;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;3;3.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;49;1630.204,1206.696;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCGrayscale;167;1394.605,1585.336;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;168;1563.605,1436.336;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0.7924528,0.7924528,0.7924528,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;162;4244.526,1236.986;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;119;3300.731,2662.246;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;3137.231,2838.858;Inherit;False;83;Splat_R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;3170.231,3003.858;Inherit;False;84;Splat_G;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;122;3537.191,2895.191;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;3323.23,3229.858;Inherit;False;85;Splat_B;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;124;3694.191,3107.191;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;2890.758,2612.627;Inherit;False;Property;_Smoothness0;Smoothness0;2;1;[HideInInspector];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;2889.083,2723.974;Inherit;False;Property;_Smoothness1;Smoothness1;3;1;[HideInInspector];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;2882.083,2916.974;Inherit;False;Property;_Smoothness2;Smoothness2;4;1;[HideInInspector];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;109;297.3248,2180.911;Inherit;False;0;58;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;281.7115,578.6722;Inherit;False;0;58;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;127;2882.083,3136.974;Inherit;False;Property;_Smoothness3;Smoothness3;5;1;[HideInInspector];Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;2529.699,3894.03;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;2666.211,4026.253;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;2843.232,3838.986;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;178;959.8502,3931.077;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;1241.345,3968.095;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;190;2173.54,4165.629;Inherit;True;Property;_TextureSample26;Texture Sample 24;28;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;d9a770fddc0276740b642075488dc8ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;203;3230.242,1169.388;Inherit;False;202;noisepath;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;181;2169.712,3933.369;Inherit;True;Property;_TextureSample25;Texture Sample 24;26;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;None;d9a770fddc0276740b642075488dc8ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;1080.04,1404.498;Inherit;True;Property;_Colormaphehe;Colormaphehe;0;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;f9e2a0ca5ddb35d4b8565db818a7733a;f9e2a0ca5ddb35d4b8565db818a7733a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;605.8863,-65.18717;Inherit;True;Property;_Splatmaphehe;Splatmaphehe;1;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;ae1c3e30ed322e548b4fffb5d4b178fb;ae1c3e30ed322e548b4fffb5d4b178fb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;4932.917,1408.032;Float;False;True;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;Terrain_Gneh;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;20;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;41;Workflow;1;0;Surface;0;0;  Refraction Model;0;0;  Blend;0;0;Two Sided;1;0;Fragment Normal Space,InvertActionOnDeselection;0;638622175585726611;Forward Only;0;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;638622178361808313;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;638622178409228524;_FinalColorxAlpha;0;0;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;0;0;Tessellation;0;638629103579815818;  Phong;0;638622181388556815;  Strength;0.5,False,;0;  Type;0;638629103561742847;  Tess;16,False,;638622180960055978;  Min;10,False,;638622181921356503;  Max;25,False,;638622181776756284;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Write Depth;0;638622175447046850;  Early Z;0;0;Vertex Position,InvertActionOnDeselection;1;638629103269552649;Debug Display;0;0;Clear Coat;0;0;0;10;False;True;True;True;True;True;True;True;True;True;True;;True;0
Node;AmplifyShaderEditor.WireNode;146;2427.246,1596.66;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;172;2173.974,3708.829;Inherit;True;Property;_TextureSample24;Texture Sample 24;27;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;b4e1e739d65ec7f41bc99511a1f33bcf;d9a770fddc0276740b642075488dc8ac;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;174;1939.382,3711.847;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;150,150;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;225;1227.909,3590.499;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;1761.311,3677.047;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;1568.413,3806.538;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;226;1541.997,3686.045;Inherit;False;Constant;_Vector0;Vector 0;27;0;Create;True;0;0;0;False;0;False;150,150;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;1577.828,4055.995;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;182;1764.151,4019.143;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;180;1936.764,3936.067;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;100,100;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;229;1541.997,3932.912;Inherit;False;Constant;_Vector1;Vector 0;27;0;Create;True;0;0;0;False;0;False;100,100;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;1763.56,3914.917;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;1575.574,4293.159;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;193;1773.674,4265.498;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;1778.744,4167.408;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;192;1937.948,4169.648;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;50,50;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;230;1551.557,4178.655;Inherit;False;Constant;_Vector2;Vector 0;27;0;Create;True;0;0;0;False;0;False;50,50;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;177;1757.832,3772.177;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;211;1213.808,3386.169;Inherit;True;Property;_Noise_Emission;Noise_Emission;26;0;Create;True;1;;0;0;False;0;False;b4e1e739d65ec7f41bc99511a1f33bcf;d9a770fddc0276740b642075488dc8ac;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;153;4116.292,1981.318;Float;False;Property;_AmbiantOcclusion0;AmbiantOcclusion0;19;1;[HideInInspector];Create;True;0;0;0;False;0;False;0.3318382;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;224;4393.258,1596.307;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;154;3420.615,1561.947;Inherit;True;Property;_struggle_map;struggle_map;23;1;[HideInInspector];Create;True;0;0;0;False;0;False;-1;3654a761a141e7b418559a041ad907f5;3654a761a141e7b418559a041ad907f5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;159;3713.115,1612.147;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;206;3014.05,3923.97;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;3200.797,3846.163;Inherit;False;noisepath;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;234;3981.253,1525.173;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;235;3221.614,1237.904;Inherit;False;Property;_Emission;Emission;25;1;[HDR];Create;True;0;0;0;False;0;False;7.975868,7.780234,7.780234,0;2.118547,2.118547,2.118547,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;201;927.1849,4038.109;Inherit;False;Property;_AnimationSpeed;AnimationSpeed;24;0;Create;True;0;0;0;False;0;False;0;0.157;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;3543.504,1163.209;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;237;3755.62,1720.155;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;3980.736,1663.356;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;3766.436,1035.933;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;166;4305.54,1419.053;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;243;4820.552,1023.301;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;244;4659.552,942.3013;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.1,0.1,0.1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ReflectionProbeNode;245;4450.396,854.0688;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
WireConnection;52;0;51;0
WireConnection;52;1;53;0
WireConnection;83;0;33;1
WireConnection;84;0;33;2
WireConnection;85;0;33;3
WireConnection;92;0;33;1
WireConnection;92;1;33;2
WireConnection;92;2;33;3
WireConnection;59;82;57;0
WireConnection;59;5;37;0
WireConnection;60;82;54;0
WireConnection;60;5;40;0
WireConnection;55;82;56;0
WireConnection;55;5;38;0
WireConnection;99;0;98;0
WireConnection;99;1;149;0
WireConnection;99;2;105;0
WireConnection;101;82;108;0
WireConnection;101;5;110;0
WireConnection;102;82;107;0
WireConnection;61;82;58;0
WireConnection;61;5;41;0
WireConnection;112;82;113;0
WireConnection;112;5;114;0
WireConnection;45;0;61;0
WireConnection;45;1;59;0
WireConnection;45;2;86;0
WireConnection;46;0;45;0
WireConnection;46;1;60;0
WireConnection;46;2;87;0
WireConnection;47;0;46;0
WireConnection;47;1;55;0
WireConnection;47;2;88;0
WireConnection;128;0;141;0
WireConnection;128;1;138;0
WireConnection;128;2;129;0
WireConnection;131;0;128;0
WireConnection;131;1;139;0
WireConnection;131;2;130;0
WireConnection;133;0;131;0
WireConnection;133;1;140;0
WireConnection;133;2;132;0
WireConnection;100;0;99;0
WireConnection;100;1;152;0
WireConnection;100;2;106;0
WireConnection;103;82;111;0
WireConnection;103;5;109;0
WireConnection;98;0;144;0
WireConnection;98;1;147;0
WireConnection;98;2;104;0
WireConnection;144;0;103;0
WireConnection;144;1;145;0
WireConnection;147;0;101;0
WireConnection;147;1;148;0
WireConnection;149;0;102;0
WireConnection;149;1;150;0
WireConnection;152;0;112;0
WireConnection;152;1;151;0
WireConnection;51;0;49;0
WireConnection;51;1;168;0
WireConnection;49;0;47;0
WireConnection;167;0;10;0
WireConnection;168;0;10;0
WireConnection;168;1;167;0
WireConnection;162;0;163;0
WireConnection;162;1;52;0
WireConnection;162;2;234;0
WireConnection;119;0;13;0
WireConnection;119;1;125;0
WireConnection;119;2;120;0
WireConnection;122;0;119;0
WireConnection;122;1;126;0
WireConnection;122;2;121;0
WireConnection;124;0;122;0
WireConnection;124;1;127;0
WireConnection;124;2;123;0
WireConnection;184;0;172;1
WireConnection;184;1;181;1
WireConnection;198;0;184;0
WireConnection;198;1;190;1
WireConnection;187;0;198;0
WireConnection;199;0;178;0
WireConnection;199;1;201;0
WireConnection;190;0;211;0
WireConnection;190;1;192;0
WireConnection;181;0;211;0
WireConnection;181;1;180;0
WireConnection;1;0;243;0
WireConnection;1;1;166;0
WireConnection;1;3;133;0
WireConnection;1;4;124;0
WireConnection;1;5;153;0
WireConnection;1;8;224;0
WireConnection;146;0;100;0
WireConnection;172;0;211;0
WireConnection;172;1;174;0
WireConnection;174;0;227;0
WireConnection;174;1;177;0
WireConnection;225;0;211;0
WireConnection;227;0;225;0
WireConnection;227;1;226;0
WireConnection;189;0;199;0
WireConnection;179;0;199;0
WireConnection;182;0;179;0
WireConnection;180;0;228;0
WireConnection;180;1;182;0
WireConnection;228;0;225;0
WireConnection;228;1;229;0
WireConnection;197;0;199;0
WireConnection;193;1;197;0
WireConnection;231;0;225;0
WireConnection;231;1;230;0
WireConnection;192;0;231;0
WireConnection;192;1;193;0
WireConnection;177;1;189;0
WireConnection;224;1;223;0
WireConnection;159;0;154;2
WireConnection;206;0;187;0
WireConnection;202;0;206;0
WireConnection;234;0;159;0
WireConnection;205;0;203;0
WireConnection;205;1;235;0
WireConnection;237;0;203;0
WireConnection;223;0;159;0
WireConnection;163;0;52;0
WireConnection;163;1;205;0
WireConnection;166;0;146;0
WireConnection;166;1;234;0
WireConnection;243;0;162;0
WireConnection;243;1;244;0
WireConnection;244;0;245;0
WireConnection;245;1;166;0
ASEEND*/
//CHKSM=C52EC016182590E403684199EB292FCDD43F9284