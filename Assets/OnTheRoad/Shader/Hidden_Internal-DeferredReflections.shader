//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-DeferredReflections" {
Properties {
_SrcBlend ("", Float) = 1
_DstBlend ("", Float) = 1
}
SubShader {
 Pass {
  Blend Zero Zero, Zero Zero
  ZWrite Off
  GpuProgramID 19311
Program "vp" {
SubProgram "gles " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform lowp samplerCube unity_SpecCube0;
uniform highp vec4 unity_SpecCube0_BoxMax;
uniform highp vec4 unity_SpecCube0_BoxMin;
uniform highp vec4 unity_SpecCube0_ProbePosition;
uniform mediump vec4 unity_SpecCube0_HDR;
uniform highp vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  mediump vec4 gbuffer2_5;
  mediump vec4 gbuffer1_6;
  mediump vec4 gbuffer0_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_7 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_5 = tmpvar_13;
  mediump float tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_14 = gbuffer1_6.w;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((gbuffer2_5.xyz * 2.0) - 1.0));
  tmpvar_15 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump float tmpvar_18;
  tmpvar_18 = (1.0 - max (max (gbuffer1_6.x, gbuffer1_6.y), gbuffer1_6.z));
  tmpvar_1 = -(tmpvar_17);
  tmpvar_4 = unity_SpecCube0_HDR;
  tmpvar_2.w = 1.0;
  highp float tmpvar_19;
  tmpvar_19 = unity_SpecCube1_ProbePosition.w;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.x = tmpvar_19;
  tmpvar_20.y = tmpvar_19;
  tmpvar_20.z = tmpvar_19;
  tmpvar_2.xyz = (unity_SpecCube0_BoxMin - tmpvar_20).xyz;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.x = tmpvar_19;
  tmpvar_21.y = tmpvar_19;
  tmpvar_21.z = tmpvar_19;
  tmpvar_3.xyz = (unity_SpecCube0_BoxMax + tmpvar_21).xyz;
  mediump vec3 Normal_22;
  Normal_22 = tmpvar_15;
  mediump float tmpvar_23;
  highp float tmpvar_24;
  highp float smoothness_25;
  smoothness_25 = tmpvar_14;
  tmpvar_24 = (1.0 - smoothness_25);
  tmpvar_23 = tmpvar_24;
  mediump vec3 tmpvar_26;
  mediump vec3 I_27;
  I_27 = -(tmpvar_1);
  tmpvar_26 = (I_27 - (2.0 * (
    dot (Normal_22, I_27)
   * Normal_22)));
  mediump vec3 tmpvar_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = tmpvar_26;
  highp vec3 worldRefl_30;
  worldRefl_30 = tmpvar_26;
  highp vec3 worldPos_31;
  worldPos_31 = tmpvar_10;
  if ((unity_SpecCube0_ProbePosition.w > 0.0)) {
    highp vec3 tmpvar_32;
    tmpvar_32 = normalize(worldRefl_30);
    highp vec3 tmpvar_33;
    tmpvar_33 = ((tmpvar_3.xyz - tmpvar_10) / tmpvar_32);
    highp vec3 tmpvar_34;
    tmpvar_34 = ((tmpvar_2.xyz - tmpvar_10) / tmpvar_32);
    bvec3 tmpvar_35;
    tmpvar_35 = greaterThan (tmpvar_32, vec3(0.0, 0.0, 0.0));
    highp float tmpvar_36;
    if (tmpvar_35.x) {
      tmpvar_36 = tmpvar_33.x;
    } else {
      tmpvar_36 = tmpvar_34.x;
    };
    highp float tmpvar_37;
    if (tmpvar_35.y) {
      tmpvar_37 = tmpvar_33.y;
    } else {
      tmpvar_37 = tmpvar_34.y;
    };
    highp float tmpvar_38;
    if (tmpvar_35.z) {
      tmpvar_38 = tmpvar_33.z;
    } else {
      tmpvar_38 = tmpvar_34.z;
    };
    worldPos_31 = (tmpvar_10 - unity_SpecCube0_ProbePosition.xyz);
    worldRefl_30 = (worldPos_31 + (tmpvar_32 * min (
      min (tmpvar_36, tmpvar_37)
    , tmpvar_38)));
  };
  tmpvar_29 = worldRefl_30;
  mediump vec4 hdr_39;
  hdr_39 = tmpvar_4;
  mediump vec4 tmpvar_40;
  tmpvar_40.xyz = tmpvar_29;
  tmpvar_40.w = ((tmpvar_23 * (1.7 - 
    (0.7 * tmpvar_23)
  )) * 6.0);
  lowp vec4 tmpvar_41;
  tmpvar_41 = impl_low_textureCubeLodEXT (unity_SpecCube0, tmpvar_29, tmpvar_40.w);
  mediump vec4 tmpvar_42;
  tmpvar_42 = tmpvar_41;
  tmpvar_28 = (((hdr_39.x * 
    ((hdr_39.w * (tmpvar_42.w - 1.0)) + 1.0)
  ) * tmpvar_42.xyz) * gbuffer0_7.w);
  highp vec3 viewDir_43;
  viewDir_43 = -(tmpvar_17);
  mediump float surfaceReduction_44;
  mediump float specularTerm_45;
  mediump float nv_46;
  highp float tmpvar_47;
  highp float smoothness_48;
  smoothness_48 = tmpvar_14;
  tmpvar_47 = (1.0 - smoothness_48);
  highp vec3 inVec_49;
  inVec_49 = (vec3(0.0, 1.0, 0.0) + viewDir_43);
  highp float tmpvar_50;
  tmpvar_50 = abs(dot (tmpvar_15, viewDir_43));
  nv_46 = tmpvar_50;
  mediump float tmpvar_51;
  highp float tmpvar_52;
  tmpvar_52 = clamp (tmpvar_15.y, 0.0, 1.0);
  tmpvar_51 = tmpvar_52;
  highp float tmpvar_53;
  tmpvar_53 = clamp (dot (tmpvar_15, (inVec_49 * 
    inversesqrt(max (0.001, dot (inVec_49, inVec_49)))
  )), 0.0, 1.0);
  highp float tmpvar_54;
  tmpvar_54 = max ((tmpvar_47 * tmpvar_47), 0.002);
  mediump float tmpvar_55;
  mediump float roughness_56;
  roughness_56 = tmpvar_54;
  tmpvar_55 = (0.5 / ((
    (tmpvar_51 * ((nv_46 * (1.0 - roughness_56)) + roughness_56))
   + 
    (nv_46 * ((tmpvar_51 * (1.0 - roughness_56)) + roughness_56))
  ) + 1e-5));
  highp float tmpvar_57;
  tmpvar_57 = (tmpvar_54 * tmpvar_54);
  highp float tmpvar_58;
  tmpvar_58 = (((
    (tmpvar_53 * tmpvar_57)
   - tmpvar_53) * tmpvar_53) + 1.0);
  highp float tmpvar_59;
  tmpvar_59 = ((tmpvar_55 * (
    (0.3183099 * tmpvar_57)
   / 
    ((tmpvar_58 * tmpvar_58) + 1e-7)
  )) * 3.141593);
  specularTerm_45 = tmpvar_59;
  mediump float tmpvar_60;
  tmpvar_60 = max (0.0, (sqrt(
    max (0.0001, specularTerm_45)
  ) * tmpvar_51));
  specularTerm_45 = tmpvar_60;
  surfaceReduction_44 = (1.0 - ((0.28 * tmpvar_54) * tmpvar_47));
  bvec3 tmpvar_61;
  tmpvar_61 = bvec3(gbuffer1_6.xyz);
  bool tmpvar_62;
  tmpvar_62 = any(tmpvar_61);
  highp float tmpvar_63;
  if (tmpvar_62) {
    tmpvar_63 = 1.0;
  } else {
    tmpvar_63 = 0.0;
  };
  specularTerm_45 = (tmpvar_60 * tmpvar_63);
  mediump float x_64;
  x_64 = (1.0 - nv_46);
  mediump vec4 tmpvar_65;
  tmpvar_65.w = 1.0;
  tmpvar_65.xyz = ((surfaceReduction_44 * tmpvar_28) * mix (gbuffer1_6.xyz, vec3(clamp (
    (gbuffer1_6.w + (1.0 - tmpvar_18))
  , 0.0, 1.0)), vec3((
    (x_64 * x_64)
   * 
    ((x_64 * x_64) * x_64)
  ))));
  mediump vec3 p_66;
  p_66 = tmpvar_10;
  mediump vec3 aabbMin_67;
  aabbMin_67 = unity_SpecCube0_BoxMin.xyz;
  mediump vec3 aabbMax_68;
  aabbMax_68 = unity_SpecCube0_BoxMax.xyz;
  mediump vec3 tmpvar_69;
  tmpvar_69 = max (max ((p_66 - aabbMax_68), (aabbMin_67 - p_66)), vec3(0.0, 0.0, 0.0));
  mediump float tmpvar_70;
  tmpvar_70 = sqrt(dot (tmpvar_69, tmpvar_69));
  mediump float tmpvar_71;
  highp float tmpvar_72;
  tmpvar_72 = clamp ((1.0 - (tmpvar_70 / unity_SpecCube1_ProbePosition.w)), 0.0, 1.0);
  tmpvar_71 = tmpvar_72;
  mediump vec4 tmpvar_73;
  tmpvar_73.xyz = tmpvar_65.xyz;
  tmpvar_73.w = tmpvar_71;
  gl_FragData[0] = tmpvar_73;
}


#endif
"
}
SubProgram "gles3 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _LightAsQuad;
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
vec4 u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position = u_xlat1;
    u_xlat1.y = u_xlat1.y * _ProjectionParams.x;
    u_xlat2.xzw = u_xlat1.xwy * vec3(0.5, 0.5, 0.5);
    vs_TEXCOORD0.zw = u_xlat1.zw;
    vs_TEXCOORD0.xy = u_xlat2.zz + u_xlat2.xw;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_MatrixV[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_MatrixV[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_MatrixV[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_MatrixV[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + in_NORMAL0.xyz;
    vs_TEXCOORD1.xyz = vec3(_LightAsQuad) * u_xlat0.xyz + u_xlat1.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es
#ifdef GL_EXT_shader_texture_lod
#extension GL_EXT_shader_texture_lod : enable
#endif

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	vec4 unity_SpecCube0_ProbePosition;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube unity_SpecCube0;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
mediump vec3 u_xlat16_1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
vec3 u_xlat6;
vec3 u_xlat7;
bvec3 u_xlatb8;
mediump vec3 u_xlat16_9;
mediump vec3 u_xlat16_14;
mediump vec3 u_xlat16_19;
float u_xlat30;
lowp float u_xlat10_30;
float u_xlat31;
mediump float u_xlat16_31;
float u_xlat33;
mediump float u_xlat16_33;
bool u_xlatb33;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat30 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat30 = _ZBufferParams.x * u_xlat30 + _ZBufferParams.y;
    u_xlat30 = float(1.0) / u_xlat30;
    u_xlat0.xyz = vec3(u_xlat30) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat10_30 = texture(_CameraGBufferTexture0, u_xlat1.xy).w;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_1.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_1.xyz, u_xlat16_1.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_1.xyz = vec3(u_xlat16_31) * u_xlat16_1.xyz;
    u_xlat3.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat31 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat31 = inversesqrt(u_xlat31);
    u_xlat3.xyz = vec3(u_xlat31) * u_xlat3.xyz;
    u_xlat16_4.x = max(u_xlat10_2.y, u_xlat10_2.x);
    u_xlat16_4.x = max(u_xlat10_2.z, u_xlat16_4.x);
    u_xlat16_4.x = (-u_xlat16_4.x) + 1.0;
    u_xlat16_31 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_14.x = dot(u_xlat3.xyz, u_xlat16_1.xyz);
    u_xlat16_14.x = u_xlat16_14.x + u_xlat16_14.x;
    u_xlat16_14.xyz = u_xlat16_1.xyz * (-u_xlat16_14.xxx) + u_xlat3.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb33 = !!(0.0<unity_SpecCube0_ProbePosition.w);
#else
    u_xlatb33 = 0.0<unity_SpecCube0_ProbePosition.w;
#endif
    if(u_xlatb33){
        u_xlat5.xyz = unity_SpecCube0_BoxMin.xyz + (-unity_SpecCube1_ProbePosition.www);
        u_xlat6.xyz = unity_SpecCube0_BoxMax.xyz + unity_SpecCube1_ProbePosition.www;
        u_xlat16_33 = dot(u_xlat16_14.xyz, u_xlat16_14.xyz);
        u_xlat16_33 = inversesqrt(u_xlat16_33);
        u_xlat7.xyz = vec3(u_xlat16_33) * u_xlat16_14.xyz;
        u_xlat6.xyz = (-u_xlat0.xyz) + u_xlat6.xyz;
        u_xlat6.xyz = u_xlat6.xyz / u_xlat7.xyz;
        u_xlat5.xyz = (-u_xlat0.xyz) + u_xlat5.xyz;
        u_xlat5.xyz = u_xlat5.xyz / u_xlat7.xyz;
        u_xlatb8.xyz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat7.xyzx).xyz;
        {
            vec3 hlslcc_movcTemp = u_xlat5;
            u_xlat5.x = (u_xlatb8.x) ? u_xlat6.x : hlslcc_movcTemp.x;
            u_xlat5.y = (u_xlatb8.y) ? u_xlat6.y : hlslcc_movcTemp.y;
            u_xlat5.z = (u_xlatb8.z) ? u_xlat6.z : hlslcc_movcTemp.z;
        }
        u_xlat33 = min(u_xlat5.y, u_xlat5.x);
        u_xlat33 = min(u_xlat5.z, u_xlat33);
        u_xlat5.xyz = u_xlat0.xyz + (-unity_SpecCube0_ProbePosition.xyz);
        u_xlat5.xyz = u_xlat7.xyz * vec3(u_xlat33) + u_xlat5.xyz;
    } else {
        u_xlat5.xyz = u_xlat16_14.xyz;
    //ENDIF
    }
    u_xlat16_14.x = (-u_xlat16_31) * 0.699999988 + 1.70000005;
    u_xlat16_14.x = u_xlat16_31 * u_xlat16_14.x;
    u_xlat16_14.x = u_xlat16_14.x * 6.0;
    u_xlat10_5 = textureLod(unity_SpecCube0, u_xlat5.xyz, u_xlat16_14.x);
    u_xlat16_14.x = u_xlat10_5.w + -1.0;
    u_xlat16_14.x = unity_SpecCube0_HDR.w * u_xlat16_14.x + 1.0;
    u_xlat16_14.x = u_xlat16_14.x * unity_SpecCube0_HDR.x;
    u_xlat16_14.xyz = u_xlat10_5.xyz * u_xlat16_14.xxx;
    u_xlat16_14.xyz = vec3(u_xlat10_30) * u_xlat16_14.xyz;
    u_xlat30 = dot(u_xlat16_1.xyz, (-u_xlat3.xyz));
    u_xlat16_1.x = u_xlat16_31 * u_xlat16_31;
    u_xlat16_1.x = max(u_xlat16_1.x, 0.00200000009);
    u_xlat16_1.x = u_xlat16_1.x * u_xlat16_31;
    u_xlat16_1.x = (-u_xlat16_1.x) * 0.280000001 + 1.0;
    u_xlat16_4.x = (-u_xlat16_4.x) + 1.0;
    u_xlat16_4.x = u_xlat10_2.w + u_xlat16_4.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_14.xyz = u_xlat16_14.xyz * u_xlat16_1.xxx;
    u_xlat16_9.x = -abs(u_xlat30) + 1.0;
    u_xlat16_19.x = u_xlat16_9.x * u_xlat16_9.x;
    u_xlat16_19.x = u_xlat16_19.x * u_xlat16_19.x;
    u_xlat16_9.x = u_xlat16_9.x * u_xlat16_19.x;
    u_xlat16_19.xyz = (-u_xlat10_2.xyz) + u_xlat16_4.xxx;
    u_xlat16_9.xyz = u_xlat16_9.xxx * u_xlat16_19.xyz + u_xlat10_2.xyz;
    SV_Target0.xyz = u_xlat16_14.xyz * u_xlat16_9.xyz;
    u_xlat16_4.xyz = u_xlat0.xyz + (-unity_SpecCube0_BoxMax.xyz);
    u_xlat16_9.xyz = (-u_xlat0.xyz) + unity_SpecCube0_BoxMin.xyz;
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, u_xlat16_9.xyz);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = sqrt(u_xlat16_4.x);
    u_xlat0.x = u_xlat16_4.x / unity_SpecCube1_ProbePosition.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    SV_Target0.w = u_xlat0.x;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles " {
""
}
SubProgram "gles3 " {
""
}
}
}
 Pass {
  Blend Zero Zero, Zero Zero
  ZTest Always
  ZWrite Off
  GpuProgramID 113442
Program "vp" {
SubProgram "gles " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = exp2(-(c_1.xyz));
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles3 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = exp2((-u_xlat10_0.xyz));
    SV_Target0.w = 0.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "UNITY_HDR_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = c_1.xyz;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "UNITY_HDR_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = u_xlat10_0.xyz;
    SV_Target0.w = 0.0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles " {
""
}
SubProgram "gles3 " {
""
}
SubProgram "gles " {
Keywords { "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "UNITY_HDR_ON" }
""
}
}
}
}
}