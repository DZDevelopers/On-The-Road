//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-DeferredShading" {
Properties {
_LightTexture0 ("", any) = "" { }
_LightTextureB0 ("", 2D) = "" { }
_ShadowMapTexture ("", any) = "" { }
_SrcBlend ("", Float) = 1
_DstBlend ("", Float) = 1
}
SubShader {
 Pass {
  Tags { "SHADOWSUPPORT" = "true" }
  Blend Zero Zero, Zero Zero
  ZWrite Off
  GpuProgramID 7517
Program "vp" {
SubProgram "gles " {
Keywords { "POINT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).x;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_15;
  mediump float tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_16 = gbuffer1_3.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_17 = tmpvar_18;
  highp vec3 viewDir_19;
  viewDir_19 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_20;
  mediump float nv_21;
  highp float tmpvar_22;
  highp float smoothness_23;
  smoothness_23 = tmpvar_16;
  tmpvar_22 = (1.0 - smoothness_23);
  highp vec3 tmpvar_24;
  highp vec3 inVec_25;
  inVec_25 = (lightDir_7 + viewDir_19);
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  highp float tmpvar_26;
  tmpvar_26 = abs(dot (tmpvar_17, viewDir_19));
  nv_21 = tmpvar_26;
  mediump float tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_17, lightDir_7), 0.0, 1.0);
  tmpvar_27 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_17, tmpvar_24), 0.0, 1.0);
  mediump float tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (dot (lightDir_7, tmpvar_24), 0.0, 1.0);
  tmpvar_30 = tmpvar_31;
  mediump float perceptualRoughness_32;
  perceptualRoughness_32 = tmpvar_22;
  mediump float tmpvar_33;
  tmpvar_33 = (0.5 + ((2.0 * tmpvar_30) * (tmpvar_30 * perceptualRoughness_32)));
  mediump float x_34;
  x_34 = (1.0 - tmpvar_27);
  mediump float x_35;
  x_35 = (1.0 - nv_21);
  mediump float tmpvar_36;
  tmpvar_36 = (((1.0 + 
    ((tmpvar_33 - 1.0) * ((x_34 * x_34) * ((x_34 * x_34) * x_34)))
  ) * (1.0 + 
    ((tmpvar_33 - 1.0) * ((x_35 * x_35) * ((x_35 * x_35) * x_35)))
  )) * tmpvar_27);
  highp float tmpvar_37;
  tmpvar_37 = max ((tmpvar_22 * tmpvar_22), 0.002);
  mediump float tmpvar_38;
  mediump float roughness_39;
  roughness_39 = tmpvar_37;
  tmpvar_38 = (0.5 / ((
    (tmpvar_27 * ((nv_21 * (1.0 - roughness_39)) + roughness_39))
   + 
    (nv_21 * ((tmpvar_27 * (1.0 - roughness_39)) + roughness_39))
  ) + 1e-5));
  highp float tmpvar_40;
  tmpvar_40 = (tmpvar_37 * tmpvar_37);
  highp float tmpvar_41;
  tmpvar_41 = (((
    (tmpvar_29 * tmpvar_40)
   - tmpvar_29) * tmpvar_29) + 1.0);
  highp float tmpvar_42;
  tmpvar_42 = ((tmpvar_38 * (
    (0.3183099 * tmpvar_40)
   / 
    ((tmpvar_41 * tmpvar_41) + 1e-7)
  )) * 3.141593);
  specularTerm_20 = tmpvar_42;
  mediump float tmpvar_43;
  tmpvar_43 = max (0.0, (sqrt(
    max (0.0001, specularTerm_20)
  ) * tmpvar_27));
  specularTerm_20 = tmpvar_43;
  bvec3 tmpvar_44;
  tmpvar_44 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_45;
  tmpvar_45 = any(tmpvar_44);
  highp float tmpvar_46;
  if (tmpvar_45) {
    tmpvar_46 = 1.0;
  } else {
    tmpvar_46 = 0.0;
  };
  specularTerm_20 = (tmpvar_43 * tmpvar_46);
  mediump float x_47;
  x_47 = (1.0 - tmpvar_30);
  mediump vec4 tmpvar_48;
  tmpvar_48.w = 1.0;
  tmpvar_48.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_36)) + ((specularTerm_20 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_47 * x_47) * ((x_47 * x_47) * x_47)))
  )));
  mediump vec4 tmpvar_49;
  tmpvar_49 = exp2(-(tmpvar_48));
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
lowp vec3 u_xlat10_5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat8;
mediump float u_xlat16_8;
bool u_xlatb8;
mediump float u_xlat16_14;
mediump vec3 u_xlat16_15;
mediump float u_xlat16_16;
float u_xlat17;
mediump float u_xlat16_22;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat24 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat17 = inversesqrt(u_xlat24);
    u_xlat24 = u_xlat24 * _LightPos.w;
    u_xlat24 = texture(_LightTextureB0, vec2(u_xlat24)).x;
    u_xlat3.xyz = vec3(u_xlat24) * _LightColor.xyz;
    u_xlat4.xyz = (-u_xlat0.xyz) * vec3(u_xlat17) + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat17);
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_5.xyz = vec3(u_xlat16_24) * u_xlat16_5.xyz;
    u_xlat24 = dot(u_xlat16_5.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-u_xlat0.xyz), u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_5.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat4.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat4.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_6.x = (-u_xlat16_26) + 1.0;
    u_xlat16_14 = abs(u_xlat8) * u_xlat16_6.x + u_xlat16_26;
    u_xlat16_6.x = u_xlat0.x * u_xlat16_6.x + u_xlat16_26;
    u_xlat16_6.x = abs(u_xlat8) * u_xlat16_6.x;
    u_xlat16_22 = -abs(u_xlat8) + 1.0;
    u_xlat16_6.x = u_xlat0.x * u_xlat16_14 + u_xlat16_6.x;
    u_xlat16_8 = u_xlat16_6.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8 = u_xlat24 * u_xlat16_8;
    u_xlat8 = u_xlat8 * 3.14159274;
    u_xlat8 = max(u_xlat8, 9.99999975e-05);
    u_xlat8 = sqrt(u_xlat8);
    u_xlat16_6.x = u_xlat0.x * u_xlat8;
    u_xlat16_14 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_14!=0.0);
#else
    u_xlatb8 = u_xlat16_14!=0.0;
#endif
    u_xlat8 = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_6.x = u_xlat8 * u_xlat16_6.x;
    u_xlat16_6.xyw = u_xlat3.xyz * u_xlat16_6.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_6.xyw = u_xlat16_6.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_22 = u_xlat16_7.x * u_xlat16_22 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_22 = u_xlat0.x * u_xlat16_22;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_22);
    u_xlat16_0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_6.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_9;
  tmpvar_5 = _LightColor.xyz;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_12;
  mediump float tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = gbuffer1_3.w;
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_14 = tmpvar_15;
  highp vec3 viewDir_16;
  viewDir_16 = -(normalize((
    (unity_CameraToWorld * tmpvar_8)
  .xyz - _WorldSpaceCameraPos)));
  mediump float specularTerm_17;
  mediump float nv_18;
  highp float tmpvar_19;
  highp float smoothness_20;
  smoothness_20 = tmpvar_13;
  tmpvar_19 = (1.0 - smoothness_20);
  highp vec3 tmpvar_21;
  highp vec3 inVec_22;
  inVec_22 = (lightDir_6 + viewDir_16);
  tmpvar_21 = (inVec_22 * inversesqrt(max (0.001, 
    dot (inVec_22, inVec_22)
  )));
  highp float tmpvar_23;
  tmpvar_23 = abs(dot (tmpvar_14, viewDir_16));
  nv_18 = tmpvar_23;
  mediump float tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_14, lightDir_6), 0.0, 1.0);
  tmpvar_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_14, tmpvar_21), 0.0, 1.0);
  mediump float tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (lightDir_6, tmpvar_21), 0.0, 1.0);
  tmpvar_27 = tmpvar_28;
  mediump float perceptualRoughness_29;
  perceptualRoughness_29 = tmpvar_19;
  mediump float tmpvar_30;
  tmpvar_30 = (0.5 + ((2.0 * tmpvar_27) * (tmpvar_27 * perceptualRoughness_29)));
  mediump float x_31;
  x_31 = (1.0 - tmpvar_24);
  mediump float x_32;
  x_32 = (1.0 - nv_18);
  mediump float tmpvar_33;
  tmpvar_33 = (((1.0 + 
    ((tmpvar_30 - 1.0) * ((x_31 * x_31) * ((x_31 * x_31) * x_31)))
  ) * (1.0 + 
    ((tmpvar_30 - 1.0) * ((x_32 * x_32) * ((x_32 * x_32) * x_32)))
  )) * tmpvar_24);
  highp float tmpvar_34;
  tmpvar_34 = max ((tmpvar_19 * tmpvar_19), 0.002);
  mediump float tmpvar_35;
  mediump float roughness_36;
  roughness_36 = tmpvar_34;
  tmpvar_35 = (0.5 / ((
    (tmpvar_24 * ((nv_18 * (1.0 - roughness_36)) + roughness_36))
   + 
    (nv_18 * ((tmpvar_24 * (1.0 - roughness_36)) + roughness_36))
  ) + 1e-5));
  highp float tmpvar_37;
  tmpvar_37 = (tmpvar_34 * tmpvar_34);
  highp float tmpvar_38;
  tmpvar_38 = (((
    (tmpvar_26 * tmpvar_37)
   - tmpvar_26) * tmpvar_26) + 1.0);
  highp float tmpvar_39;
  tmpvar_39 = ((tmpvar_35 * (
    (0.3183099 * tmpvar_37)
   / 
    ((tmpvar_38 * tmpvar_38) + 1e-7)
  )) * 3.141593);
  specularTerm_17 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = max (0.0, (sqrt(
    max (0.0001, specularTerm_17)
  ) * tmpvar_24));
  specularTerm_17 = tmpvar_40;
  bvec3 tmpvar_41;
  tmpvar_41 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_42;
  tmpvar_42 = any(tmpvar_41);
  highp float tmpvar_43;
  if (tmpvar_42) {
    tmpvar_43 = 1.0;
  } else {
    tmpvar_43 = 0.0;
  };
  specularTerm_17 = (tmpvar_40 * tmpvar_43);
  mediump float x_44;
  x_44 = (1.0 - tmpvar_27);
  mediump vec4 tmpvar_45;
  tmpvar_45.w = 1.0;
  tmpvar_45.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_33)) + ((specularTerm_17 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_44 * x_44) * ((x_44 * x_44) * x_44)))
  )));
  mediump vec4 tmpvar_46;
  tmpvar_46 = exp2(-(tmpvar_45));
  tmpvar_1 = tmpvar_46;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
lowp vec3 u_xlat10_3;
mediump float u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
float u_xlat11;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_19;
mediump float u_xlat16_20;
float u_xlat21;
mediump float u_xlat16_21;
mediump float u_xlat16_23;
mediump float u_xlat16_24;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat0.xyz) * vec3(u_xlat21) + (-_LightDir.xyz);
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = max(u_xlat21, 0.00100000005);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_3.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_21 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_21 = inversesqrt(u_xlat16_21);
    u_xlat16_3.xyz = vec3(u_xlat16_21) * u_xlat16_3.xyz;
    u_xlat21 = dot(u_xlat16_3.xyz, u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat21 = min(max(u_xlat21, 0.0), 1.0);
#else
    u_xlat21 = clamp(u_xlat21, 0.0, 1.0);
#endif
    u_xlat15 = dot((-_LightDir.xyz), u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat15 = min(max(u_xlat15, 0.0), 1.0);
#else
    u_xlat15 = clamp(u_xlat15, 0.0, 1.0);
#endif
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_23 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_24 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_24 = max(u_xlat16_24, 0.00200000009);
    u_xlat16_4 = u_xlat16_24 * u_xlat16_24;
    u_xlat11 = u_xlat21 * u_xlat16_4 + (-u_xlat21);
    u_xlat21 = u_xlat11 * u_xlat21 + 1.0;
    u_xlat21 = u_xlat21 * u_xlat21 + 1.00000001e-07;
    u_xlat16_4 = u_xlat16_4 * 0.318309873;
    u_xlat21 = u_xlat16_4 / u_xlat21;
    u_xlat0.x = dot(u_xlat16_3.xyz, (-u_xlat0.xyz));
    u_xlat7 = dot(u_xlat16_3.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat16_5.x = (-u_xlat16_24) + 1.0;
    u_xlat16_12 = abs(u_xlat0.x) * u_xlat16_5.x + u_xlat16_24;
    u_xlat16_5.x = u_xlat7 * u_xlat16_5.x + u_xlat16_24;
    u_xlat16_5.x = abs(u_xlat0.x) * u_xlat16_5.x;
    u_xlat16_19 = -abs(u_xlat0.x) + 1.0;
    u_xlat16_5.x = u_xlat7 * u_xlat16_12 + u_xlat16_5.x;
    u_xlat16_0.x = u_xlat16_5.x + 9.99999975e-06;
    u_xlat16_0.x = 0.5 / u_xlat16_0.x;
    u_xlat0.x = u_xlat21 * u_xlat16_0.x;
    u_xlat0.x = u_xlat0.x * 3.14159274;
    u_xlat0.x = max(u_xlat0.x, 9.99999975e-05);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat16_5.x = u_xlat7 * u_xlat0.x;
    u_xlat16_12 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb0 = u_xlat16_12!=0.0;
#endif
    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
    u_xlat16_5.x = u_xlat0.x * u_xlat16_5.x;
    u_xlat16_5.xyw = u_xlat16_5.xxx * _LightColor.xyz;
    u_xlat16_6.x = (-u_xlat15) + 1.0;
    u_xlat16_13.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_13.x;
    u_xlat16_13.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_6.xyz = u_xlat16_13.xyz * u_xlat16_6.xxx + u_xlat10_2.xyz;
    u_xlat16_5.xyw = u_xlat16_5.xyw * u_xlat16_6.xyz;
    u_xlat16_6.x = u_xlat15 + u_xlat15;
    u_xlat16_6.x = u_xlat15 * u_xlat16_6.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_23 + -0.5;
    u_xlat16_13.x = u_xlat16_19 * u_xlat16_19;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_19 = u_xlat16_19 * u_xlat16_13.x;
    u_xlat16_19 = u_xlat16_6.x * u_xlat16_19 + 1.0;
    u_xlat16_13.x = (-u_xlat7) + 1.0;
    u_xlat16_20 = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_20;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_20;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_13.x + 1.0;
    u_xlat16_19 = u_xlat16_19 * u_xlat16_6.x;
    u_xlat16_19 = u_xlat7 * u_xlat16_19;
    u_xlat16_6.xyz = vec3(u_xlat16_19) * _LightColor.xyz;
    u_xlat16_0.xyz = u_xlat10_1.xyw * u_xlat16_6.xyz + u_xlat16_5.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).x);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  mediump float tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_19 = gbuffer1_3.w;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_20 = tmpvar_21;
  highp vec3 viewDir_22;
  viewDir_22 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_23;
  mediump float nv_24;
  highp float tmpvar_25;
  highp float smoothness_26;
  smoothness_26 = tmpvar_19;
  tmpvar_25 = (1.0 - smoothness_26);
  highp vec3 tmpvar_27;
  highp vec3 inVec_28;
  inVec_28 = (lightDir_7 + viewDir_22);
  tmpvar_27 = (inVec_28 * inversesqrt(max (0.001, 
    dot (inVec_28, inVec_28)
  )));
  highp float tmpvar_29;
  tmpvar_29 = abs(dot (tmpvar_20, viewDir_22));
  nv_24 = tmpvar_29;
  mediump float tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (dot (tmpvar_20, lightDir_7), 0.0, 1.0);
  tmpvar_30 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_20, tmpvar_27), 0.0, 1.0);
  mediump float tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (dot (lightDir_7, tmpvar_27), 0.0, 1.0);
  tmpvar_33 = tmpvar_34;
  mediump float perceptualRoughness_35;
  perceptualRoughness_35 = tmpvar_25;
  mediump float tmpvar_36;
  tmpvar_36 = (0.5 + ((2.0 * tmpvar_33) * (tmpvar_33 * perceptualRoughness_35)));
  mediump float x_37;
  x_37 = (1.0 - tmpvar_30);
  mediump float x_38;
  x_38 = (1.0 - nv_24);
  mediump float tmpvar_39;
  tmpvar_39 = (((1.0 + 
    ((tmpvar_36 - 1.0) * ((x_37 * x_37) * ((x_37 * x_37) * x_37)))
  ) * (1.0 + 
    ((tmpvar_36 - 1.0) * ((x_38 * x_38) * ((x_38 * x_38) * x_38)))
  )) * tmpvar_30);
  highp float tmpvar_40;
  tmpvar_40 = max ((tmpvar_25 * tmpvar_25), 0.002);
  mediump float tmpvar_41;
  mediump float roughness_42;
  roughness_42 = tmpvar_40;
  tmpvar_41 = (0.5 / ((
    (tmpvar_30 * ((nv_24 * (1.0 - roughness_42)) + roughness_42))
   + 
    (nv_24 * ((tmpvar_30 * (1.0 - roughness_42)) + roughness_42))
  ) + 1e-5));
  highp float tmpvar_43;
  tmpvar_43 = (tmpvar_40 * tmpvar_40);
  highp float tmpvar_44;
  tmpvar_44 = (((
    (tmpvar_32 * tmpvar_43)
   - tmpvar_32) * tmpvar_32) + 1.0);
  highp float tmpvar_45;
  tmpvar_45 = ((tmpvar_41 * (
    (0.3183099 * tmpvar_43)
   / 
    ((tmpvar_44 * tmpvar_44) + 1e-7)
  )) * 3.141593);
  specularTerm_23 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = max (0.0, (sqrt(
    max (0.0001, specularTerm_23)
  ) * tmpvar_30));
  specularTerm_23 = tmpvar_46;
  bvec3 tmpvar_47;
  tmpvar_47 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_48;
  tmpvar_48 = any(tmpvar_47);
  highp float tmpvar_49;
  if (tmpvar_48) {
    tmpvar_49 = 1.0;
  } else {
    tmpvar_49 = 0.0;
  };
  specularTerm_23 = (tmpvar_46 * tmpvar_49);
  mediump float x_50;
  x_50 = (1.0 - tmpvar_33);
  mediump vec4 tmpvar_51;
  tmpvar_51.w = 1.0;
  tmpvar_51.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_39)) + ((specularTerm_23 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_50 * x_50) * ((x_50 * x_50) * x_50)))
  )));
  mediump vec4 tmpvar_52;
  tmpvar_52 = exp2(-(tmpvar_51));
  tmpvar_1 = tmpvar_52;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
vec3 u_xlat4;
lowp vec3 u_xlat10_4;
mediump vec3 u_xlat16_5;
lowp vec3 u_xlat10_5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat9;
mediump float u_xlat16_9;
bool u_xlatb9;
mediump float u_xlat16_10;
mediump float u_xlat16_14;
mediump vec3 u_xlat16_15;
float u_xlat16;
bool u_xlatb16;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat18;
mediump float u_xlat16_22;
mediump float u_xlat16_23;
float u_xlat24;
float u_xlat25;
float u_xlat26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat3.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat17 = inversesqrt(u_xlat24);
    u_xlat24 = u_xlat24 * _LightPos.w;
    u_xlat24 = texture(_LightTextureB0, vec2(u_xlat24)).x;
    u_xlat4.xyz = u_xlat3.xyz * vec3(u_xlat17) + (-u_xlat2.xyz);
    u_xlat3.xyz = vec3(u_xlat17) * u_xlat3.xyz;
    u_xlat17 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat17 = max(u_xlat17, 0.00100000005);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat4.xyz = vec3(u_xlat17) * u_xlat4.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_17 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_17 = inversesqrt(u_xlat16_17);
    u_xlat16_5.xyz = vec3(u_xlat16_17) * u_xlat16_5.xyz;
    u_xlat17 = dot(u_xlat16_5.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat25 = dot(u_xlat3.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat25 = min(max(u_xlat25, 0.0), 1.0);
#else
    u_xlat25 = clamp(u_xlat25, 0.0, 1.0);
#endif
    u_xlat26 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat26 = min(max(u_xlat26, 0.0), 1.0);
#else
    u_xlat26 = clamp(u_xlat26, 0.0, 1.0);
#endif
    u_xlat2.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_4.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_1 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_9 = u_xlat16_1 * u_xlat16_1;
    u_xlat16_9 = max(u_xlat16_9, 0.00200000009);
    u_xlat16_10 = u_xlat16_9 * u_xlat16_9;
    u_xlat18 = u_xlat17 * u_xlat16_10 + (-u_xlat17);
    u_xlat17 = u_xlat18 * u_xlat17 + 1.0;
    u_xlat17 = u_xlat17 * u_xlat17 + 1.00000001e-07;
    u_xlat16_10 = u_xlat16_10 * 0.318309873;
    u_xlat17 = u_xlat16_10 / u_xlat17;
    u_xlat16_6.x = (-u_xlat16_9) + 1.0;
    u_xlat16_14 = abs(u_xlat2.x) * u_xlat16_6.x + u_xlat16_9;
    u_xlat16_6.x = u_xlat26 * u_xlat16_6.x + u_xlat16_9;
    u_xlat16_6.x = abs(u_xlat2.x) * u_xlat16_6.x;
    u_xlat16_22 = -abs(u_xlat2.x) + 1.0;
    u_xlat16_6.x = u_xlat26 * u_xlat16_14 + u_xlat16_6.x;
    u_xlat16_9 = u_xlat16_6.x + 9.99999975e-06;
    u_xlat16_9 = 0.5 / u_xlat16_9;
    u_xlat9 = u_xlat17 * u_xlat16_9;
    u_xlat9 = u_xlat9 * 3.14159274;
    u_xlat9 = max(u_xlat9, 9.99999975e-05);
    u_xlat9 = sqrt(u_xlat9);
    u_xlat16_6.x = u_xlat26 * u_xlat9;
    u_xlat16_14 = dot(u_xlat10_3.xyz, u_xlat10_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb9 = !!(u_xlat16_14!=0.0);
#else
    u_xlatb9 = u_xlat16_14!=0.0;
#endif
    u_xlat9 = u_xlatb9 ? 1.0 : float(0.0);
    u_xlat16_6.x = u_xlat9 * u_xlat16_6.x;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb16 = !!(u_xlat0.z<0.0);
#else
    u_xlatb16 = u_xlat0.z<0.0;
#endif
    u_xlat16 = u_xlatb16 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat16 * u_xlat0.x;
    u_xlat0.x = u_xlat24 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_6.xyw = u_xlat0.xyz * u_xlat16_6.xxx;
    u_xlat16_7.x = (-u_xlat25) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_3.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_3.xyz;
    u_xlat16_6.xyw = u_xlat16_6.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat25 + u_xlat25;
    u_xlat16_7.x = u_xlat25 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_1 + -0.5;
    u_xlat16_22 = u_xlat16_7.x * u_xlat16_22 + 1.0;
    u_xlat16_15.x = (-u_xlat26) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_22 = u_xlat26 * u_xlat16_22;
    u_xlat16_7.xyz = u_xlat0.xyz * vec3(u_xlat16_22);
    u_xlat16_0.xyz = u_xlat10_4.xyz * u_xlat16_7.xyz + u_xlat16_6.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).x;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.w = -8.0;
  tmpvar_14.xyz = (unity_WorldToLight * tmpvar_13).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_14.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump float tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_18 = gbuffer1_3.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_19 = tmpvar_20;
  highp vec3 viewDir_21;
  viewDir_21 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_22;
  mediump float nv_23;
  highp float tmpvar_24;
  highp float smoothness_25;
  smoothness_25 = tmpvar_18;
  tmpvar_24 = (1.0 - smoothness_25);
  highp vec3 tmpvar_26;
  highp vec3 inVec_27;
  inVec_27 = (lightDir_7 + viewDir_21);
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  highp float tmpvar_28;
  tmpvar_28 = abs(dot (tmpvar_19, viewDir_21));
  nv_23 = tmpvar_28;
  mediump float tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_19, lightDir_7), 0.0, 1.0);
  tmpvar_29 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (dot (tmpvar_19, tmpvar_26), 0.0, 1.0);
  mediump float tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp (dot (lightDir_7, tmpvar_26), 0.0, 1.0);
  tmpvar_32 = tmpvar_33;
  mediump float perceptualRoughness_34;
  perceptualRoughness_34 = tmpvar_24;
  mediump float tmpvar_35;
  tmpvar_35 = (0.5 + ((2.0 * tmpvar_32) * (tmpvar_32 * perceptualRoughness_34)));
  mediump float x_36;
  x_36 = (1.0 - tmpvar_29);
  mediump float x_37;
  x_37 = (1.0 - nv_23);
  mediump float tmpvar_38;
  tmpvar_38 = (((1.0 + 
    ((tmpvar_35 - 1.0) * ((x_36 * x_36) * ((x_36 * x_36) * x_36)))
  ) * (1.0 + 
    ((tmpvar_35 - 1.0) * ((x_37 * x_37) * ((x_37 * x_37) * x_37)))
  )) * tmpvar_29);
  highp float tmpvar_39;
  tmpvar_39 = max ((tmpvar_24 * tmpvar_24), 0.002);
  mediump float tmpvar_40;
  mediump float roughness_41;
  roughness_41 = tmpvar_39;
  tmpvar_40 = (0.5 / ((
    (tmpvar_29 * ((nv_23 * (1.0 - roughness_41)) + roughness_41))
   + 
    (nv_23 * ((tmpvar_29 * (1.0 - roughness_41)) + roughness_41))
  ) + 1e-5));
  highp float tmpvar_42;
  tmpvar_42 = (tmpvar_39 * tmpvar_39);
  highp float tmpvar_43;
  tmpvar_43 = (((
    (tmpvar_31 * tmpvar_42)
   - tmpvar_31) * tmpvar_31) + 1.0);
  highp float tmpvar_44;
  tmpvar_44 = ((tmpvar_40 * (
    (0.3183099 * tmpvar_42)
   / 
    ((tmpvar_43 * tmpvar_43) + 1e-7)
  )) * 3.141593);
  specularTerm_22 = tmpvar_44;
  mediump float tmpvar_45;
  tmpvar_45 = max (0.0, (sqrt(
    max (0.0001, specularTerm_22)
  ) * tmpvar_29));
  specularTerm_22 = tmpvar_45;
  bvec3 tmpvar_46;
  tmpvar_46 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_47;
  tmpvar_47 = any(tmpvar_46);
  highp float tmpvar_48;
  if (tmpvar_47) {
    tmpvar_48 = 1.0;
  } else {
    tmpvar_48 = 0.0;
  };
  specularTerm_22 = (tmpvar_45 * tmpvar_48);
  mediump float x_49;
  x_49 = (1.0 - tmpvar_32);
  mediump vec4 tmpvar_50;
  tmpvar_50.w = 1.0;
  tmpvar_50.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_38)) + ((specularTerm_22 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_49 * x_49) * ((x_49 * x_49) * x_49)))
  )));
  mediump vec4 tmpvar_51;
  tmpvar_51 = exp2(-(tmpvar_50));
  tmpvar_1 = tmpvar_51;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
vec3 u_xlat4;
lowp vec3 u_xlat10_4;
mediump vec3 u_xlat16_5;
lowp vec3 u_xlat10_5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat9;
mediump float u_xlat16_9;
bool u_xlatb9;
mediump float u_xlat16_10;
mediump float u_xlat16_14;
mediump vec3 u_xlat16_15;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat18;
mediump float u_xlat16_22;
mediump float u_xlat16_23;
float u_xlat24;
float u_xlat25;
float u_xlat26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat17 = inversesqrt(u_xlat24);
    u_xlat24 = u_xlat24 * _LightPos.w;
    u_xlat24 = texture(_LightTextureB0, vec2(u_xlat24)).x;
    u_xlat4.xyz = (-u_xlat3.xyz) * vec3(u_xlat17) + (-u_xlat2.xyz);
    u_xlat3.xyz = vec3(u_xlat17) * u_xlat3.xyz;
    u_xlat17 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat17 = max(u_xlat17, 0.00100000005);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat4.xyz = vec3(u_xlat17) * u_xlat4.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_17 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_17 = inversesqrt(u_xlat16_17);
    u_xlat16_5.xyz = vec3(u_xlat16_17) * u_xlat16_5.xyz;
    u_xlat17 = dot(u_xlat16_5.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat25 = dot((-u_xlat3.xyz), u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat25 = min(max(u_xlat25, 0.0), 1.0);
#else
    u_xlat25 = clamp(u_xlat25, 0.0, 1.0);
#endif
    u_xlat26 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat26 = min(max(u_xlat26, 0.0), 1.0);
#else
    u_xlat26 = clamp(u_xlat26, 0.0, 1.0);
#endif
    u_xlat2.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_4.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_1 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_9 = u_xlat16_1 * u_xlat16_1;
    u_xlat16_9 = max(u_xlat16_9, 0.00200000009);
    u_xlat16_10 = u_xlat16_9 * u_xlat16_9;
    u_xlat18 = u_xlat17 * u_xlat16_10 + (-u_xlat17);
    u_xlat17 = u_xlat18 * u_xlat17 + 1.0;
    u_xlat17 = u_xlat17 * u_xlat17 + 1.00000001e-07;
    u_xlat16_10 = u_xlat16_10 * 0.318309873;
    u_xlat17 = u_xlat16_10 / u_xlat17;
    u_xlat16_6.x = (-u_xlat16_9) + 1.0;
    u_xlat16_14 = abs(u_xlat2.x) * u_xlat16_6.x + u_xlat16_9;
    u_xlat16_6.x = u_xlat26 * u_xlat16_6.x + u_xlat16_9;
    u_xlat16_6.x = abs(u_xlat2.x) * u_xlat16_6.x;
    u_xlat16_22 = -abs(u_xlat2.x) + 1.0;
    u_xlat16_6.x = u_xlat26 * u_xlat16_14 + u_xlat16_6.x;
    u_xlat16_9 = u_xlat16_6.x + 9.99999975e-06;
    u_xlat16_9 = 0.5 / u_xlat16_9;
    u_xlat9 = u_xlat17 * u_xlat16_9;
    u_xlat9 = u_xlat9 * 3.14159274;
    u_xlat9 = max(u_xlat9, 9.99999975e-05);
    u_xlat9 = sqrt(u_xlat9);
    u_xlat16_6.x = u_xlat26 * u_xlat9;
    u_xlat16_14 = dot(u_xlat10_3.xyz, u_xlat10_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb9 = !!(u_xlat16_14!=0.0);
#else
    u_xlatb9 = u_xlat16_14!=0.0;
#endif
    u_xlat9 = u_xlatb9 ? 1.0 : float(0.0);
    u_xlat16_6.x = u_xlat9 * u_xlat16_6.x;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat24;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_6.xyw = u_xlat0.xyz * u_xlat16_6.xxx;
    u_xlat16_7.x = (-u_xlat25) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_3.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_3.xyz;
    u_xlat16_6.xyw = u_xlat16_6.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat25 + u_xlat25;
    u_xlat16_7.x = u_xlat25 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_1 + -0.5;
    u_xlat16_22 = u_xlat16_7.x * u_xlat16_22 + 1.0;
    u_xlat16_15.x = (-u_xlat26) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_22 = u_xlat26 * u_xlat16_22;
    u_xlat16_7.xyz = u_xlat0.xyz * vec3(u_xlat16_22);
    u_xlat16_0.xyz = u_xlat10_4.xyz * u_xlat16_7.xyz + u_xlat16_6.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  highp vec4 tmpvar_13;
  tmpvar_13.zw = vec2(0.0, -8.0);
  tmpvar_13.xy = (unity_WorldToLight * tmpvar_12).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_13.xy, -8.0).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_16;
  mediump float tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_17 = gbuffer1_3.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_18 = tmpvar_19;
  highp vec3 viewDir_20;
  viewDir_20 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_21;
  mediump float nv_22;
  highp float tmpvar_23;
  highp float smoothness_24;
  smoothness_24 = tmpvar_17;
  tmpvar_23 = (1.0 - smoothness_24);
  highp vec3 tmpvar_25;
  highp vec3 inVec_26;
  inVec_26 = (lightDir_7 + viewDir_20);
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  highp float tmpvar_27;
  tmpvar_27 = abs(dot (tmpvar_18, viewDir_20));
  nv_22 = tmpvar_27;
  mediump float tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_18, lightDir_7), 0.0, 1.0);
  tmpvar_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_18, tmpvar_25), 0.0, 1.0);
  mediump float tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp (dot (lightDir_7, tmpvar_25), 0.0, 1.0);
  tmpvar_31 = tmpvar_32;
  mediump float perceptualRoughness_33;
  perceptualRoughness_33 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = (0.5 + ((2.0 * tmpvar_31) * (tmpvar_31 * perceptualRoughness_33)));
  mediump float x_35;
  x_35 = (1.0 - tmpvar_28);
  mediump float x_36;
  x_36 = (1.0 - nv_22);
  mediump float tmpvar_37;
  tmpvar_37 = (((1.0 + 
    ((tmpvar_34 - 1.0) * ((x_35 * x_35) * ((x_35 * x_35) * x_35)))
  ) * (1.0 + 
    ((tmpvar_34 - 1.0) * ((x_36 * x_36) * ((x_36 * x_36) * x_36)))
  )) * tmpvar_28);
  highp float tmpvar_38;
  tmpvar_38 = max ((tmpvar_23 * tmpvar_23), 0.002);
  mediump float tmpvar_39;
  mediump float roughness_40;
  roughness_40 = tmpvar_38;
  tmpvar_39 = (0.5 / ((
    (tmpvar_28 * ((nv_22 * (1.0 - roughness_40)) + roughness_40))
   + 
    (nv_22 * ((tmpvar_28 * (1.0 - roughness_40)) + roughness_40))
  ) + 1e-5));
  highp float tmpvar_41;
  tmpvar_41 = (tmpvar_38 * tmpvar_38);
  highp float tmpvar_42;
  tmpvar_42 = (((
    (tmpvar_30 * tmpvar_41)
   - tmpvar_30) * tmpvar_30) + 1.0);
  highp float tmpvar_43;
  tmpvar_43 = ((tmpvar_39 * (
    (0.3183099 * tmpvar_41)
   / 
    ((tmpvar_42 * tmpvar_42) + 1e-7)
  )) * 3.141593);
  specularTerm_21 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = max (0.0, (sqrt(
    max (0.0001, specularTerm_21)
  ) * tmpvar_28));
  specularTerm_21 = tmpvar_44;
  bvec3 tmpvar_45;
  tmpvar_45 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_46;
  tmpvar_46 = any(tmpvar_45);
  highp float tmpvar_47;
  if (tmpvar_46) {
    tmpvar_47 = 1.0;
  } else {
    tmpvar_47 = 0.0;
  };
  specularTerm_21 = (tmpvar_44 * tmpvar_47);
  mediump float x_48;
  x_48 = (1.0 - tmpvar_31);
  mediump vec4 tmpvar_49;
  tmpvar_49.w = 1.0;
  tmpvar_49.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_37)) + ((specularTerm_21 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_48 * x_48) * ((x_48 * x_48) * x_48)))
  )));
  mediump vec4 tmpvar_50;
  tmpvar_50 = exp2(-(tmpvar_49));
  tmpvar_1 = tmpvar_50;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
mediump float u_xlat16_2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_4;
float u_xlat5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
float u_xlat10;
mediump float u_xlat16_14;
mediump vec3 u_xlat16_15;
float u_xlat17;
mediump float u_xlat16_22;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
bool u_xlatb24;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
mediump float u_xlat16_28;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-_LightDir.xyz);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_4.xyz = vec3(u_xlat16_24) * u_xlat16_4.xyz;
    u_xlat24 = dot(u_xlat16_4.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-_LightDir.xyz), u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_26 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_27 = max(u_xlat16_27, 0.00200000009);
    u_xlat16_28 = u_xlat16_27 * u_xlat16_27;
    u_xlat5 = u_xlat24 * u_xlat16_28 + (-u_xlat24);
    u_xlat24 = u_xlat5 * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_28 = u_xlat16_28 * 0.318309873;
    u_xlat24 = u_xlat16_28 / u_xlat24;
    u_xlat2.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
    u_xlat10 = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat10 = min(max(u_xlat10, 0.0), 1.0);
#else
    u_xlat10 = clamp(u_xlat10, 0.0, 1.0);
#endif
    u_xlat16_6.x = (-u_xlat16_27) + 1.0;
    u_xlat16_14 = abs(u_xlat2.x) * u_xlat16_6.x + u_xlat16_27;
    u_xlat16_6.x = u_xlat10 * u_xlat16_6.x + u_xlat16_27;
    u_xlat16_6.x = abs(u_xlat2.x) * u_xlat16_6.x;
    u_xlat16_22 = -abs(u_xlat2.x) + 1.0;
    u_xlat16_6.x = u_xlat10 * u_xlat16_14 + u_xlat16_6.x;
    u_xlat16_2 = u_xlat16_6.x + 9.99999975e-06;
    u_xlat16_2 = 0.5 / u_xlat16_2;
    u_xlat24 = u_xlat24 * u_xlat16_2;
    u_xlat24 = u_xlat24 * 3.14159274;
    u_xlat24 = max(u_xlat24, 9.99999975e-05);
    u_xlat24 = sqrt(u_xlat24);
    u_xlat16_6.x = u_xlat10 * u_xlat24;
    u_xlat16_14 = dot(u_xlat10_3.xyz, u_xlat10_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb24 = !!(u_xlat16_14!=0.0);
#else
    u_xlatb24 = u_xlat16_14!=0.0;
#endif
    u_xlat24 = u_xlatb24 ? 1.0 : float(0.0);
    u_xlat16_6.x = u_xlat24 * u_xlat16_6.x;
    u_xlat8.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat8.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_6.xyw = u_xlat0.xyz * u_xlat16_6.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_3.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_3.xyz;
    u_xlat16_6.xyw = u_xlat16_6.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_26 + -0.5;
    u_xlat16_15.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_15.x;
    u_xlat16_22 = u_xlat16_7.x * u_xlat16_22 + 1.0;
    u_xlat16_15.x = (-u_xlat10) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_22 = u_xlat10 * u_xlat16_22;
    u_xlat16_7.xyz = u_xlat0.xyz * vec3(u_xlat16_22);
    u_xlat16_0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_6.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).x);
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_ShadowMapTexture, tmpvar_21);
  mediump float tmpvar_24;
  if ((tmpvar_23.x < (tmpvar_21.z / tmpvar_21.w))) {
    tmpvar_24 = _LightShadowData.x;
  } else {
    tmpvar_24 = 1.0;
  };
  tmpvar_22 = tmpvar_24;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_25;
  tmpvar_25 = mix (shadowAttenuation_19, 1.0, tmpvar_17);
  atten_6 = (atten_6 * tmpvar_25);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump float tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_29 = gbuffer1_3.w;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_30 = tmpvar_31;
  highp vec3 viewDir_32;
  viewDir_32 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_33;
  mediump float nv_34;
  highp float tmpvar_35;
  highp float smoothness_36;
  smoothness_36 = tmpvar_29;
  tmpvar_35 = (1.0 - smoothness_36);
  highp vec3 tmpvar_37;
  highp vec3 inVec_38;
  inVec_38 = (lightDir_7 + viewDir_32);
  tmpvar_37 = (inVec_38 * inversesqrt(max (0.001, 
    dot (inVec_38, inVec_38)
  )));
  highp float tmpvar_39;
  tmpvar_39 = abs(dot (tmpvar_30, viewDir_32));
  nv_34 = tmpvar_39;
  mediump float tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_30, lightDir_7), 0.0, 1.0);
  tmpvar_40 = tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = clamp (dot (tmpvar_30, tmpvar_37), 0.0, 1.0);
  mediump float tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = clamp (dot (lightDir_7, tmpvar_37), 0.0, 1.0);
  tmpvar_43 = tmpvar_44;
  mediump float perceptualRoughness_45;
  perceptualRoughness_45 = tmpvar_35;
  mediump float tmpvar_46;
  tmpvar_46 = (0.5 + ((2.0 * tmpvar_43) * (tmpvar_43 * perceptualRoughness_45)));
  mediump float x_47;
  x_47 = (1.0 - tmpvar_40);
  mediump float x_48;
  x_48 = (1.0 - nv_34);
  mediump float tmpvar_49;
  tmpvar_49 = (((1.0 + 
    ((tmpvar_46 - 1.0) * ((x_47 * x_47) * ((x_47 * x_47) * x_47)))
  ) * (1.0 + 
    ((tmpvar_46 - 1.0) * ((x_48 * x_48) * ((x_48 * x_48) * x_48)))
  )) * tmpvar_40);
  highp float tmpvar_50;
  tmpvar_50 = max ((tmpvar_35 * tmpvar_35), 0.002);
  mediump float tmpvar_51;
  mediump float roughness_52;
  roughness_52 = tmpvar_50;
  tmpvar_51 = (0.5 / ((
    (tmpvar_40 * ((nv_34 * (1.0 - roughness_52)) + roughness_52))
   + 
    (nv_34 * ((tmpvar_40 * (1.0 - roughness_52)) + roughness_52))
  ) + 1e-5));
  highp float tmpvar_53;
  tmpvar_53 = (tmpvar_50 * tmpvar_50);
  highp float tmpvar_54;
  tmpvar_54 = (((
    (tmpvar_42 * tmpvar_53)
   - tmpvar_42) * tmpvar_42) + 1.0);
  highp float tmpvar_55;
  tmpvar_55 = ((tmpvar_51 * (
    (0.3183099 * tmpvar_53)
   / 
    ((tmpvar_54 * tmpvar_54) + 1e-7)
  )) * 3.141593);
  specularTerm_33 = tmpvar_55;
  mediump float tmpvar_56;
  tmpvar_56 = max (0.0, (sqrt(
    max (0.0001, specularTerm_33)
  ) * tmpvar_40));
  specularTerm_33 = tmpvar_56;
  bvec3 tmpvar_57;
  tmpvar_57 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_58;
  tmpvar_58 = any(tmpvar_57);
  highp float tmpvar_59;
  if (tmpvar_58) {
    tmpvar_59 = 1.0;
  } else {
    tmpvar_59 = 0.0;
  };
  specularTerm_33 = (tmpvar_56 * tmpvar_59);
  mediump float x_60;
  x_60 = (1.0 - tmpvar_43);
  mediump vec4 tmpvar_61;
  tmpvar_61.w = 1.0;
  tmpvar_61.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_49)) + ((specularTerm_33 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_60 * x_60) * ((x_60 * x_60) * x_60)))
  )));
  mediump vec4 tmpvar_62;
  tmpvar_62 = exp2(-(tmpvar_61));
  tmpvar_1 = tmpvar_62;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
mediump vec4 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
bool u_xlatb8;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_15;
float u_xlat16;
mediump float u_xlat16_16;
bool u_xlatb16;
float u_xlat17;
mediump float u_xlat16_20;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat8.xyz = u_xlat3.xyz / u_xlat3.www;
    vec3 txVec0 = vec3(u_xlat8.xy,u_xlat8.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_16 = (-_LightShadowData.x) + 1.0;
    u_xlat16_8 = u_xlat10_8 * u_xlat16_16 + _LightShadowData.x;
    u_xlat16_4.x = (-u_xlat16_8) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_4.x + u_xlat16_8;
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb16 = !!(u_xlat0.z<0.0);
#else
    u_xlatb16 = u_xlat0.z<0.0;
#endif
    u_xlat16 = u_xlatb16 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat16 * u_xlat0.x;
    u_xlat8.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat25 = texture(_LightTextureB0, vec2(u_xlat25)).x;
    u_xlat0.x = u_xlat0.x * u_xlat25;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat5.xyz = u_xlat8.xyz * vec3(u_xlat17) + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat8.xyz * vec3(u_xlat17);
    u_xlat24 = dot(u_xlat5.xyz, u_xlat5.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat5.xyz = vec3(u_xlat24) * u_xlat5.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_6.xyz = vec3(u_xlat16_24) * u_xlat16_6.xyz;
    u_xlat24 = dot(u_xlat16_6.xyz, u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot(u_xlat0.xyz, u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_6.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.x = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat5.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat5.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_4.x = (-u_xlat16_26) + 1.0;
    u_xlat16_12 = abs(u_xlat8.x) * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = abs(u_xlat8.x) * u_xlat16_4.x;
    u_xlat16_20 = -abs(u_xlat8.x) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_12 + u_xlat16_4.x;
    u_xlat16_8 = u_xlat16_4.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8.x = u_xlat24 * u_xlat16_8;
    u_xlat8.x = u_xlat8.x * 3.14159274;
    u_xlat8.x = max(u_xlat8.x, 9.99999975e-05);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat16_4.x = u_xlat0.x * u_xlat8.x;
    u_xlat16_12 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb8 = u_xlat16_12!=0.0;
#endif
    u_xlat8.x = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_4.x = u_xlat8.x * u_xlat16_4.x;
    u_xlat16_4.xyw = u_xlat3.xyz * u_xlat16_4.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_4.xyw = u_xlat16_4.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_20 * u_xlat16_20;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_20 = u_xlat16_7.x * u_xlat16_20 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_20 = u_xlat0.x * u_xlat16_20;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_20);
    u_xlat16_0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_4.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).x);
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 shadowVals_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_21.xyz / tmpvar_21.w);
  shadowVals_23.x = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_23.y = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_23.z = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_23.w = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_25;
  tmpvar_25 = lessThan (shadowVals_23, tmpvar_24.zzzz);
  mediump vec4 tmpvar_26;
  tmpvar_26 = _LightShadowData.xxxx;
  mediump float tmpvar_27;
  if (tmpvar_25.x) {
    tmpvar_27 = tmpvar_26.x;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_25.y) {
    tmpvar_28 = tmpvar_26.y;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_25.z) {
    tmpvar_29 = tmpvar_26.z;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_25.w) {
    tmpvar_30 = tmpvar_26.w;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump vec4 tmpvar_31;
  tmpvar_31.x = tmpvar_27;
  tmpvar_31.y = tmpvar_28;
  tmpvar_31.z = tmpvar_29;
  tmpvar_31.w = tmpvar_30;
  mediump float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_22 = tmpvar_32;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_33;
  tmpvar_33 = mix (shadowAttenuation_19, 1.0, tmpvar_17);
  atten_6 = (atten_6 * tmpvar_33);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_36;
  mediump float tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_37 = gbuffer1_3.w;
  mediump vec3 tmpvar_39;
  tmpvar_39 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_38 = tmpvar_39;
  highp vec3 viewDir_40;
  viewDir_40 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_41;
  mediump float nv_42;
  highp float tmpvar_43;
  highp float smoothness_44;
  smoothness_44 = tmpvar_37;
  tmpvar_43 = (1.0 - smoothness_44);
  highp vec3 tmpvar_45;
  highp vec3 inVec_46;
  inVec_46 = (lightDir_7 + viewDir_40);
  tmpvar_45 = (inVec_46 * inversesqrt(max (0.001, 
    dot (inVec_46, inVec_46)
  )));
  highp float tmpvar_47;
  tmpvar_47 = abs(dot (tmpvar_38, viewDir_40));
  nv_42 = tmpvar_47;
  mediump float tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp (dot (tmpvar_38, lightDir_7), 0.0, 1.0);
  tmpvar_48 = tmpvar_49;
  highp float tmpvar_50;
  tmpvar_50 = clamp (dot (tmpvar_38, tmpvar_45), 0.0, 1.0);
  mediump float tmpvar_51;
  highp float tmpvar_52;
  tmpvar_52 = clamp (dot (lightDir_7, tmpvar_45), 0.0, 1.0);
  tmpvar_51 = tmpvar_52;
  mediump float perceptualRoughness_53;
  perceptualRoughness_53 = tmpvar_43;
  mediump float tmpvar_54;
  tmpvar_54 = (0.5 + ((2.0 * tmpvar_51) * (tmpvar_51 * perceptualRoughness_53)));
  mediump float x_55;
  x_55 = (1.0 - tmpvar_48);
  mediump float x_56;
  x_56 = (1.0 - nv_42);
  mediump float tmpvar_57;
  tmpvar_57 = (((1.0 + 
    ((tmpvar_54 - 1.0) * ((x_55 * x_55) * ((x_55 * x_55) * x_55)))
  ) * (1.0 + 
    ((tmpvar_54 - 1.0) * ((x_56 * x_56) * ((x_56 * x_56) * x_56)))
  )) * tmpvar_48);
  highp float tmpvar_58;
  tmpvar_58 = max ((tmpvar_43 * tmpvar_43), 0.002);
  mediump float tmpvar_59;
  mediump float roughness_60;
  roughness_60 = tmpvar_58;
  tmpvar_59 = (0.5 / ((
    (tmpvar_48 * ((nv_42 * (1.0 - roughness_60)) + roughness_60))
   + 
    (nv_42 * ((tmpvar_48 * (1.0 - roughness_60)) + roughness_60))
  ) + 1e-5));
  highp float tmpvar_61;
  tmpvar_61 = (tmpvar_58 * tmpvar_58);
  highp float tmpvar_62;
  tmpvar_62 = (((
    (tmpvar_50 * tmpvar_61)
   - tmpvar_50) * tmpvar_50) + 1.0);
  highp float tmpvar_63;
  tmpvar_63 = ((tmpvar_59 * (
    (0.3183099 * tmpvar_61)
   / 
    ((tmpvar_62 * tmpvar_62) + 1e-7)
  )) * 3.141593);
  specularTerm_41 = tmpvar_63;
  mediump float tmpvar_64;
  tmpvar_64 = max (0.0, (sqrt(
    max (0.0001, specularTerm_41)
  ) * tmpvar_48));
  specularTerm_41 = tmpvar_64;
  bvec3 tmpvar_65;
  tmpvar_65 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_66;
  tmpvar_66 = any(tmpvar_65);
  highp float tmpvar_67;
  if (tmpvar_66) {
    tmpvar_67 = 1.0;
  } else {
    tmpvar_67 = 0.0;
  };
  specularTerm_41 = (tmpvar_64 * tmpvar_67);
  mediump float x_68;
  x_68 = (1.0 - tmpvar_51);
  mediump vec4 tmpvar_69;
  tmpvar_69.w = 1.0;
  tmpvar_69.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_57)) + ((specularTerm_41 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_68 * x_68) * ((x_68 * x_68) * x_68)))
  )));
  mediump vec4 tmpvar_70;
  tmpvar_70 = exp2(-(tmpvar_69));
  tmpvar_1 = tmpvar_70;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
lowp float u_xlat10_0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
mediump vec3 u_xlat16_5;
lowp vec3 u_xlat10_5;
vec4 u_xlat6;
vec4 u_xlat7;
mediump vec4 u_xlat16_8;
mediump vec3 u_xlat16_9;
vec3 u_xlat10;
mediump float u_xlat16_10;
lowp float u_xlat10_10;
bool u_xlatb10;
mediump float u_xlat16_18;
mediump vec3 u_xlat16_19;
float u_xlat20;
mediump float u_xlat16_20;
bool u_xlatb20;
vec2 u_xlat21;
lowp float u_xlat10_21;
mediump float u_xlat16_28;
mediump float u_xlat16_29;
float u_xlat30;
mediump float u_xlat16_30;
float u_xlat31;
mediump float u_xlat16_32;
mediump float u_xlat16_33;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat30 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat30 = _ZBufferParams.x * u_xlat30 + _ZBufferParams.y;
    u_xlat30 = float(1.0) / u_xlat30;
    u_xlat2.xyz = vec3(u_xlat30) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    u_xlat0.xy = u_xlat3.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat0.xy = floor(u_xlat0.xy);
    u_xlat21.xy = u_xlat3.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat0.xy);
    u_xlat3.xy = (-u_xlat21.xy) + vec2(1.0, 1.0);
    u_xlat4.xy = min(u_xlat21.xy, vec2(0.0, 0.0));
    u_xlat4.xy = (-u_xlat4.xy) * u_xlat4.xy + u_xlat3.xy;
    u_xlat5.y = u_xlat4.x;
    u_xlat3.xy = max(u_xlat21.xy, vec2(0.0, 0.0));
    u_xlat6 = u_xlat21.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat4.xz = (-u_xlat3.xy) * u_xlat3.xy + u_xlat6.yw;
    u_xlat3.xy = u_xlat6.xz * u_xlat6.xz;
    u_xlat5.z = u_xlat4.x;
    u_xlat21.xy = u_xlat3.xy * vec2(0.5, 0.5) + (-u_xlat21.xy);
    u_xlat5.x = u_xlat21.x;
    u_xlat4.x = u_xlat21.y;
    u_xlat5.w = u_xlat3.x;
    u_xlat4.w = u_xlat3.y;
    u_xlat4 = u_xlat4 * vec4(0.444440007, 0.444440007, 0.444440007, 0.222220004);
    u_xlat5 = u_xlat5 * vec4(0.444440007, 0.444440007, 0.444440007, 0.222220004);
    u_xlat6 = vec4(u_xlat5.y + u_xlat5.x, u_xlat5.w + u_xlat5.z, u_xlat5.y + u_xlat5.x, u_xlat5.w + u_xlat5.z);
    u_xlat21.xy = vec2(u_xlat5.y / u_xlat6.z, u_xlat5.w / u_xlat6.w);
    u_xlat21.xy = u_xlat21.xy + vec2(-1.5, 0.5);
    u_xlat5.xy = u_xlat21.xy * _ShadowMapTexture_TexelSize.xx;
    u_xlat7 = vec4(u_xlat4.y + u_xlat4.x, u_xlat4.y + u_xlat4.x, u_xlat4.w + u_xlat4.z, u_xlat4.w + u_xlat4.z);
    u_xlat21.xy = vec2(u_xlat4.y / u_xlat7.y, u_xlat4.w / u_xlat7.w);
    u_xlat4 = u_xlat6 * u_xlat7;
    u_xlat21.xy = u_xlat21.xy + vec2(-1.5, 0.5);
    u_xlat5.zw = u_xlat21.xy * _ShadowMapTexture_TexelSize.yy;
    u_xlat6 = u_xlat0.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xzyz;
    u_xlat5 = u_xlat0.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwyw;
    vec3 txVec0 = vec3(u_xlat6.xy,u_xlat3.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat6.zw,u_xlat3.z);
    u_xlat10_10 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat10.x = u_xlat10_10 * u_xlat4.y;
    u_xlat0.x = u_xlat4.x * u_xlat10_0 + u_xlat10.x;
    vec3 txVec2 = vec3(u_xlat5.xy,u_xlat3.z);
    u_xlat10_10 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat5.zw,u_xlat3.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat0.x = u_xlat4.z * u_xlat10_10 + u_xlat0.x;
    u_xlat0.x = u_xlat4.w * u_xlat10_21 + u_xlat0.x;
    u_xlat16_10 = (-_LightShadowData.x) + 1.0;
    u_xlat0.x = u_xlat0.x * u_xlat16_10 + _LightShadowData.x;
    u_xlat16_8.x = (-u_xlat0.x) + 1.0;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat10.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat10.x = sqrt(u_xlat10.x);
    u_xlat10.x = (-u_xlat0.z) * u_xlat30 + u_xlat10.x;
    u_xlat10.x = unity_ShadowFadeCenterAndType.w * u_xlat10.x + u_xlat2.z;
    u_xlat10.x = u_xlat10.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat10.x = min(max(u_xlat10.x, 0.0), 1.0);
#else
    u_xlat10.x = clamp(u_xlat10.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat10.x * u_xlat16_8.x + u_xlat0.x;
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb20 = !!(u_xlat0.z<0.0);
#else
    u_xlatb20 = u_xlat0.z<0.0;
#endif
    u_xlat20 = u_xlatb20 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat20 * u_xlat0.x;
    u_xlat10.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat21.x = dot(u_xlat10.xyz, u_xlat10.xyz);
    u_xlat31 = u_xlat21.x * _LightPos.w;
    u_xlat21.x = inversesqrt(u_xlat21.x);
    u_xlat31 = texture(_LightTextureB0, vec2(u_xlat31)).x;
    u_xlat0.x = u_xlat0.x * u_xlat31;
    u_xlat0.x = u_xlat16_8.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat4.xyz = u_xlat10.xyz * u_xlat21.xxx + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat10.xyz * u_xlat21.xxx;
    u_xlat30 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat30 = max(u_xlat30, 0.00100000005);
    u_xlat30 = inversesqrt(u_xlat30);
    u_xlat4.xyz = vec3(u_xlat30) * u_xlat4.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_30 = inversesqrt(u_xlat16_30);
    u_xlat16_5.xyz = vec3(u_xlat16_30) * u_xlat16_5.xyz;
    u_xlat30 = dot(u_xlat16_5.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat30 = min(max(u_xlat30, 0.0), 1.0);
#else
    u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
#endif
    u_xlat21.x = dot(u_xlat0.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat21.x = min(max(u_xlat21.x, 0.0), 1.0);
#else
    u_xlat21.x = clamp(u_xlat21.x, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_5.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_20 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_32 = u_xlat16_20 * u_xlat16_20;
    u_xlat16_32 = max(u_xlat16_32, 0.00200000009);
    u_xlat16_33 = u_xlat16_32 * u_xlat16_32;
    u_xlat4.x = u_xlat30 * u_xlat16_33 + (-u_xlat30);
    u_xlat30 = u_xlat4.x * u_xlat30 + 1.0;
    u_xlat30 = u_xlat30 * u_xlat30 + 1.00000001e-07;
    u_xlat16_33 = u_xlat16_33 * 0.318309873;
    u_xlat30 = u_xlat16_33 / u_xlat30;
    u_xlat16_8.x = (-u_xlat16_32) + 1.0;
    u_xlat16_18 = abs(u_xlat10.x) * u_xlat16_8.x + u_xlat16_32;
    u_xlat16_8.x = u_xlat0.x * u_xlat16_8.x + u_xlat16_32;
    u_xlat16_8.x = abs(u_xlat10.x) * u_xlat16_8.x;
    u_xlat16_28 = -abs(u_xlat10.x) + 1.0;
    u_xlat16_8.x = u_xlat0.x * u_xlat16_18 + u_xlat16_8.x;
    u_xlat16_10 = u_xlat16_8.x + 9.99999975e-06;
    u_xlat16_10 = 0.5 / u_xlat16_10;
    u_xlat10.x = u_xlat30 * u_xlat16_10;
    u_xlat10.x = u_xlat10.x * 3.14159274;
    u_xlat10.x = max(u_xlat10.x, 9.99999975e-05);
    u_xlat10.x = sqrt(u_xlat10.x);
    u_xlat16_8.x = u_xlat0.x * u_xlat10.x;
    u_xlat16_18 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb10 = !!(u_xlat16_18!=0.0);
#else
    u_xlatb10 = u_xlat16_18!=0.0;
#endif
    u_xlat10.x = u_xlatb10 ? 1.0 : float(0.0);
    u_xlat16_8.x = u_xlat10.x * u_xlat16_8.x;
    u_xlat16_8.xyw = u_xlat3.xyz * u_xlat16_8.xxx;
    u_xlat16_9.x = (-u_xlat21.x) + 1.0;
    u_xlat16_19.x = u_xlat16_9.x * u_xlat16_9.x;
    u_xlat16_19.x = u_xlat16_19.x * u_xlat16_19.x;
    u_xlat16_9.x = u_xlat16_9.x * u_xlat16_19.x;
    u_xlat16_19.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_9.xyz = u_xlat16_19.xyz * u_xlat16_9.xxx + u_xlat10_2.xyz;
    u_xlat16_8.xyw = u_xlat16_8.xyw * u_xlat16_9.xyz;
    u_xlat16_9.x = u_xlat16_28 * u_xlat16_28;
    u_xlat16_9.x = u_xlat16_9.x * u_xlat16_9.x;
    u_xlat16_28 = u_xlat16_28 * u_xlat16_9.x;
    u_xlat16_9.x = u_xlat21.x + u_xlat21.x;
    u_xlat16_9.x = u_xlat21.x * u_xlat16_9.x;
    u_xlat16_9.x = u_xlat16_9.x * u_xlat16_20 + -0.5;
    u_xlat16_28 = u_xlat16_9.x * u_xlat16_28 + 1.0;
    u_xlat16_19.x = (-u_xlat0.x) + 1.0;
    u_xlat16_29 = u_xlat16_19.x * u_xlat16_19.x;
    u_xlat16_29 = u_xlat16_29 * u_xlat16_29;
    u_xlat16_19.x = u_xlat16_19.x * u_xlat16_29;
    u_xlat16_9.x = u_xlat16_9.x * u_xlat16_19.x + 1.0;
    u_xlat16_28 = u_xlat16_28 * u_xlat16_9.x;
    u_xlat16_28 = u_xlat0.x * u_xlat16_28;
    u_xlat16_9.xyz = u_xlat3.xyz * vec3(u_xlat16_28);
    u_xlat16_0.xyz = u_xlat10_1.xyw * u_xlat16_9.xyz + u_xlat16_8.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = mix (shadowAttenuation_15, 1.0, tmpvar_13);
  atten_6 = tmpvar_17;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump float tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_21 = gbuffer1_3.w;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_22 = tmpvar_23;
  highp vec3 viewDir_24;
  viewDir_24 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_25;
  mediump float nv_26;
  highp float tmpvar_27;
  highp float smoothness_28;
  smoothness_28 = tmpvar_21;
  tmpvar_27 = (1.0 - smoothness_28);
  highp vec3 tmpvar_29;
  highp vec3 inVec_30;
  inVec_30 = (lightDir_7 + viewDir_24);
  tmpvar_29 = (inVec_30 * inversesqrt(max (0.001, 
    dot (inVec_30, inVec_30)
  )));
  highp float tmpvar_31;
  tmpvar_31 = abs(dot (tmpvar_22, viewDir_24));
  nv_26 = tmpvar_31;
  mediump float tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_22, lightDir_7), 0.0, 1.0);
  tmpvar_32 = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_22, tmpvar_29), 0.0, 1.0);
  mediump float tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp (dot (lightDir_7, tmpvar_29), 0.0, 1.0);
  tmpvar_35 = tmpvar_36;
  mediump float perceptualRoughness_37;
  perceptualRoughness_37 = tmpvar_27;
  mediump float tmpvar_38;
  tmpvar_38 = (0.5 + ((2.0 * tmpvar_35) * (tmpvar_35 * perceptualRoughness_37)));
  mediump float x_39;
  x_39 = (1.0 - tmpvar_32);
  mediump float x_40;
  x_40 = (1.0 - nv_26);
  mediump float tmpvar_41;
  tmpvar_41 = (((1.0 + 
    ((tmpvar_38 - 1.0) * ((x_39 * x_39) * ((x_39 * x_39) * x_39)))
  ) * (1.0 + 
    ((tmpvar_38 - 1.0) * ((x_40 * x_40) * ((x_40 * x_40) * x_40)))
  )) * tmpvar_32);
  highp float tmpvar_42;
  tmpvar_42 = max ((tmpvar_27 * tmpvar_27), 0.002);
  mediump float tmpvar_43;
  mediump float roughness_44;
  roughness_44 = tmpvar_42;
  tmpvar_43 = (0.5 / ((
    (tmpvar_32 * ((nv_26 * (1.0 - roughness_44)) + roughness_44))
   + 
    (nv_26 * ((tmpvar_32 * (1.0 - roughness_44)) + roughness_44))
  ) + 1e-5));
  highp float tmpvar_45;
  tmpvar_45 = (tmpvar_42 * tmpvar_42);
  highp float tmpvar_46;
  tmpvar_46 = (((
    (tmpvar_34 * tmpvar_45)
   - tmpvar_34) * tmpvar_34) + 1.0);
  highp float tmpvar_47;
  tmpvar_47 = ((tmpvar_43 * (
    (0.3183099 * tmpvar_45)
   / 
    ((tmpvar_46 * tmpvar_46) + 1e-7)
  )) * 3.141593);
  specularTerm_25 = tmpvar_47;
  mediump float tmpvar_48;
  tmpvar_48 = max (0.0, (sqrt(
    max (0.0001, specularTerm_25)
  ) * tmpvar_32));
  specularTerm_25 = tmpvar_48;
  bvec3 tmpvar_49;
  tmpvar_49 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_50;
  tmpvar_50 = any(tmpvar_49);
  highp float tmpvar_51;
  if (tmpvar_50) {
    tmpvar_51 = 1.0;
  } else {
    tmpvar_51 = 0.0;
  };
  specularTerm_25 = (tmpvar_48 * tmpvar_51);
  mediump float x_52;
  x_52 = (1.0 - tmpvar_35);
  mediump vec4 tmpvar_53;
  tmpvar_53.w = 1.0;
  tmpvar_53.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_41)) + ((specularTerm_25 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_52 * x_52) * ((x_52 * x_52) * x_52)))
  )));
  mediump vec4 tmpvar_54;
  tmpvar_54 = exp2(-(tmpvar_53));
  tmpvar_1 = tmpvar_54;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_3;
lowp vec3 u_xlat10_3;
mediump float u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
bool u_xlatb7;
float u_xlat11;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_13;
float u_xlat14;
float u_xlat15;
mediump float u_xlat16_15;
mediump float u_xlat16_19;
mediump float u_xlat16_20;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_23;
mediump float u_xlat16_24;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat2.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-_LightDir.xyz);
    u_xlat7.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = max(u_xlat15, 0.00100000005);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat2.xyz = vec3(u_xlat15) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_3.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_15 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_15 = inversesqrt(u_xlat16_15);
    u_xlat16_3.xyz = vec3(u_xlat16_15) * u_xlat16_3.xyz;
    u_xlat15 = dot(u_xlat16_3.xyz, u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat15 = min(max(u_xlat15, 0.0), 1.0);
#else
    u_xlat15 = clamp(u_xlat15, 0.0, 1.0);
#endif
    u_xlat22 = dot((-_LightDir.xyz), u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat22 = min(max(u_xlat22, 0.0), 1.0);
#else
    u_xlat22 = clamp(u_xlat22, 0.0, 1.0);
#endif
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_23 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_24 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_24 = max(u_xlat16_24, 0.00200000009);
    u_xlat16_4 = u_xlat16_24 * u_xlat16_24;
    u_xlat11 = u_xlat15 * u_xlat16_4 + (-u_xlat15);
    u_xlat15 = u_xlat11 * u_xlat15 + 1.0;
    u_xlat15 = u_xlat15 * u_xlat15 + 1.00000001e-07;
    u_xlat16_4 = u_xlat16_4 * 0.318309873;
    u_xlat15 = u_xlat16_4 / u_xlat15;
    u_xlat7.x = dot(u_xlat16_3.xyz, (-u_xlat7.xyz));
    u_xlat14 = dot(u_xlat16_3.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat16_5.x = (-u_xlat16_24) + 1.0;
    u_xlat16_12 = abs(u_xlat7.x) * u_xlat16_5.x + u_xlat16_24;
    u_xlat16_5.x = u_xlat14 * u_xlat16_5.x + u_xlat16_24;
    u_xlat16_5.x = abs(u_xlat7.x) * u_xlat16_5.x;
    u_xlat16_19 = -abs(u_xlat7.x) + 1.0;
    u_xlat16_5.x = u_xlat14 * u_xlat16_12 + u_xlat16_5.x;
    u_xlat16_7 = u_xlat16_5.x + 9.99999975e-06;
    u_xlat16_7 = 0.5 / u_xlat16_7;
    u_xlat7.x = u_xlat15 * u_xlat16_7;
    u_xlat7.x = u_xlat7.x * 3.14159274;
    u_xlat7.x = max(u_xlat7.x, 9.99999975e-05);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat16_5.x = u_xlat14 * u_xlat7.x;
    u_xlat16_12 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb7 = u_xlat16_12!=0.0;
#endif
    u_xlat7.x = u_xlatb7 ? 1.0 : float(0.0);
    u_xlat16_5.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat10_7 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_12 = (-u_xlat10_7) + 1.0;
    u_xlat16_12 = u_xlat0.x * u_xlat16_12 + u_xlat10_7;
    u_xlat0.xyw = vec3(u_xlat16_12) * _LightColor.xyz;
    u_xlat16_5.xyw = u_xlat0.xyw * u_xlat16_5.xxx;
    u_xlat16_6.x = (-u_xlat22) + 1.0;
    u_xlat16_13.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_13.x;
    u_xlat16_13.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_6.xyz = u_xlat16_13.xyz * u_xlat16_6.xxx + u_xlat10_2.xyz;
    u_xlat16_5.xyw = u_xlat16_5.xyw * u_xlat16_6.xyz;
    u_xlat16_6.x = u_xlat22 + u_xlat22;
    u_xlat16_6.x = u_xlat22 * u_xlat16_6.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_23 + -0.5;
    u_xlat16_13.x = u_xlat16_19 * u_xlat16_19;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_19 = u_xlat16_19 * u_xlat16_13.x;
    u_xlat16_19 = u_xlat16_6.x * u_xlat16_19 + 1.0;
    u_xlat16_13.x = (-u_xlat14) + 1.0;
    u_xlat16_20 = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_20;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_20;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_13.x + 1.0;
    u_xlat16_19 = u_xlat16_19 * u_xlat16_6.x;
    u_xlat16_19 = u_xlat14 * u_xlat16_19;
    u_xlat16_6.xyz = u_xlat0.xyw * vec3(u_xlat16_19);
    u_xlat16_0.xyz = u_xlat10_1.xyz * u_xlat16_6.xyz + u_xlat16_5.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = mix (shadowAttenuation_15, 1.0, tmpvar_13);
  atten_6 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_10;
  highp vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, -8.0);
  tmpvar_19.xy = (unity_WorldToLight * tmpvar_18).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_19.xy, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  mediump float tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_23 = gbuffer1_3.w;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_24 = tmpvar_25;
  highp vec3 viewDir_26;
  viewDir_26 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_27;
  mediump float nv_28;
  highp float tmpvar_29;
  highp float smoothness_30;
  smoothness_30 = tmpvar_23;
  tmpvar_29 = (1.0 - smoothness_30);
  highp vec3 tmpvar_31;
  highp vec3 inVec_32;
  inVec_32 = (lightDir_7 + viewDir_26);
  tmpvar_31 = (inVec_32 * inversesqrt(max (0.001, 
    dot (inVec_32, inVec_32)
  )));
  highp float tmpvar_33;
  tmpvar_33 = abs(dot (tmpvar_24, viewDir_26));
  nv_28 = tmpvar_33;
  mediump float tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_24, lightDir_7), 0.0, 1.0);
  tmpvar_34 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = clamp (dot (tmpvar_24, tmpvar_31), 0.0, 1.0);
  mediump float tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = clamp (dot (lightDir_7, tmpvar_31), 0.0, 1.0);
  tmpvar_37 = tmpvar_38;
  mediump float perceptualRoughness_39;
  perceptualRoughness_39 = tmpvar_29;
  mediump float tmpvar_40;
  tmpvar_40 = (0.5 + ((2.0 * tmpvar_37) * (tmpvar_37 * perceptualRoughness_39)));
  mediump float x_41;
  x_41 = (1.0 - tmpvar_34);
  mediump float x_42;
  x_42 = (1.0 - nv_28);
  mediump float tmpvar_43;
  tmpvar_43 = (((1.0 + 
    ((tmpvar_40 - 1.0) * ((x_41 * x_41) * ((x_41 * x_41) * x_41)))
  ) * (1.0 + 
    ((tmpvar_40 - 1.0) * ((x_42 * x_42) * ((x_42 * x_42) * x_42)))
  )) * tmpvar_34);
  highp float tmpvar_44;
  tmpvar_44 = max ((tmpvar_29 * tmpvar_29), 0.002);
  mediump float tmpvar_45;
  mediump float roughness_46;
  roughness_46 = tmpvar_44;
  tmpvar_45 = (0.5 / ((
    (tmpvar_34 * ((nv_28 * (1.0 - roughness_46)) + roughness_46))
   + 
    (nv_28 * ((tmpvar_34 * (1.0 - roughness_46)) + roughness_46))
  ) + 1e-5));
  highp float tmpvar_47;
  tmpvar_47 = (tmpvar_44 * tmpvar_44);
  highp float tmpvar_48;
  tmpvar_48 = (((
    (tmpvar_36 * tmpvar_47)
   - tmpvar_36) * tmpvar_36) + 1.0);
  highp float tmpvar_49;
  tmpvar_49 = ((tmpvar_45 * (
    (0.3183099 * tmpvar_47)
   / 
    ((tmpvar_48 * tmpvar_48) + 1e-7)
  )) * 3.141593);
  specularTerm_27 = tmpvar_49;
  mediump float tmpvar_50;
  tmpvar_50 = max (0.0, (sqrt(
    max (0.0001, specularTerm_27)
  ) * tmpvar_34));
  specularTerm_27 = tmpvar_50;
  bvec3 tmpvar_51;
  tmpvar_51 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_52;
  tmpvar_52 = any(tmpvar_51);
  highp float tmpvar_53;
  if (tmpvar_52) {
    tmpvar_53 = 1.0;
  } else {
    tmpvar_53 = 0.0;
  };
  specularTerm_27 = (tmpvar_50 * tmpvar_53);
  mediump float x_54;
  x_54 = (1.0 - tmpvar_37);
  mediump vec4 tmpvar_55;
  tmpvar_55.w = 1.0;
  tmpvar_55.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_43)) + ((specularTerm_27 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_54 * x_54) * ((x_54 * x_54) * x_54)))
  )));
  mediump vec4 tmpvar_56;
  tmpvar_56 = exp2(-(tmpvar_55));
  tmpvar_1 = tmpvar_56;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
mediump float u_xlat16_2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
lowp vec3 u_xlat10_5;
float u_xlat6;
mediump vec3 u_xlat16_7;
lowp float u_xlat10_8;
float u_xlat10;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_15;
float u_xlat17;
mediump float u_xlat16_20;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
bool u_xlatb24;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
mediump float u_xlat16_29;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_8 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_4.x = (-u_xlat10_8) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_4.x + u_xlat10_8;
    u_xlat0.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat0.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat16_4.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-_LightDir.xyz);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_5.xyz = vec3(u_xlat16_24) * u_xlat16_5.xyz;
    u_xlat24 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-_LightDir.xyz), u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_26 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_27 = max(u_xlat16_27, 0.00200000009);
    u_xlat16_29 = u_xlat16_27 * u_xlat16_27;
    u_xlat6 = u_xlat24 * u_xlat16_29 + (-u_xlat24);
    u_xlat24 = u_xlat6 * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_29 = u_xlat16_29 * 0.318309873;
    u_xlat24 = u_xlat16_29 / u_xlat24;
    u_xlat2.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat10 = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat10 = min(max(u_xlat10, 0.0), 1.0);
#else
    u_xlat10 = clamp(u_xlat10, 0.0, 1.0);
#endif
    u_xlat16_4.x = (-u_xlat16_27) + 1.0;
    u_xlat16_12 = abs(u_xlat2.x) * u_xlat16_4.x + u_xlat16_27;
    u_xlat16_4.x = u_xlat10 * u_xlat16_4.x + u_xlat16_27;
    u_xlat16_4.x = abs(u_xlat2.x) * u_xlat16_4.x;
    u_xlat16_20 = -abs(u_xlat2.x) + 1.0;
    u_xlat16_4.x = u_xlat10 * u_xlat16_12 + u_xlat16_4.x;
    u_xlat16_2 = u_xlat16_4.x + 9.99999975e-06;
    u_xlat16_2 = 0.5 / u_xlat16_2;
    u_xlat24 = u_xlat24 * u_xlat16_2;
    u_xlat24 = u_xlat24 * 3.14159274;
    u_xlat24 = max(u_xlat24, 9.99999975e-05);
    u_xlat24 = sqrt(u_xlat24);
    u_xlat16_4.x = u_xlat10 * u_xlat24;
    u_xlat16_12 = dot(u_xlat10_3.xyz, u_xlat10_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb24 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb24 = u_xlat16_12!=0.0;
#endif
    u_xlat24 = u_xlatb24 ? 1.0 : float(0.0);
    u_xlat16_4.x = u_xlat24 * u_xlat16_4.x;
    u_xlat16_4.xyw = u_xlat0.xyz * u_xlat16_4.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_3.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_3.xyz;
    u_xlat16_4.xyw = u_xlat16_4.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_26 + -0.5;
    u_xlat16_15.x = u_xlat16_20 * u_xlat16_20;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_15.x;
    u_xlat16_20 = u_xlat16_7.x * u_xlat16_20 + 1.0;
    u_xlat16_15.x = (-u_xlat10) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_20 = u_xlat10 * u_xlat16_20;
    u_xlat16_7.xyz = u_xlat0.xyz * vec3(u_xlat16_20);
    u_xlat16_0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_4.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.x;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = mix (tmpvar_22, 1.0, tmpvar_15);
  atten_6 = (tmpvar_14.x * tmpvar_23);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_26;
  mediump float tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_27 = gbuffer1_3.w;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_28 = tmpvar_29;
  highp vec3 viewDir_30;
  viewDir_30 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_31;
  mediump float nv_32;
  highp float tmpvar_33;
  highp float smoothness_34;
  smoothness_34 = tmpvar_27;
  tmpvar_33 = (1.0 - smoothness_34);
  highp vec3 tmpvar_35;
  highp vec3 inVec_36;
  inVec_36 = (lightDir_7 + viewDir_30);
  tmpvar_35 = (inVec_36 * inversesqrt(max (0.001, 
    dot (inVec_36, inVec_36)
  )));
  highp float tmpvar_37;
  tmpvar_37 = abs(dot (tmpvar_28, viewDir_30));
  nv_32 = tmpvar_37;
  mediump float tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_28, lightDir_7), 0.0, 1.0);
  tmpvar_38 = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_28, tmpvar_35), 0.0, 1.0);
  mediump float tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = clamp (dot (lightDir_7, tmpvar_35), 0.0, 1.0);
  tmpvar_41 = tmpvar_42;
  mediump float perceptualRoughness_43;
  perceptualRoughness_43 = tmpvar_33;
  mediump float tmpvar_44;
  tmpvar_44 = (0.5 + ((2.0 * tmpvar_41) * (tmpvar_41 * perceptualRoughness_43)));
  mediump float x_45;
  x_45 = (1.0 - tmpvar_38);
  mediump float x_46;
  x_46 = (1.0 - nv_32);
  mediump float tmpvar_47;
  tmpvar_47 = (((1.0 + 
    ((tmpvar_44 - 1.0) * ((x_45 * x_45) * ((x_45 * x_45) * x_45)))
  ) * (1.0 + 
    ((tmpvar_44 - 1.0) * ((x_46 * x_46) * ((x_46 * x_46) * x_46)))
  )) * tmpvar_38);
  highp float tmpvar_48;
  tmpvar_48 = max ((tmpvar_33 * tmpvar_33), 0.002);
  mediump float tmpvar_49;
  mediump float roughness_50;
  roughness_50 = tmpvar_48;
  tmpvar_49 = (0.5 / ((
    (tmpvar_38 * ((nv_32 * (1.0 - roughness_50)) + roughness_50))
   + 
    (nv_32 * ((tmpvar_38 * (1.0 - roughness_50)) + roughness_50))
  ) + 1e-5));
  highp float tmpvar_51;
  tmpvar_51 = (tmpvar_48 * tmpvar_48);
  highp float tmpvar_52;
  tmpvar_52 = (((
    (tmpvar_40 * tmpvar_51)
   - tmpvar_40) * tmpvar_40) + 1.0);
  highp float tmpvar_53;
  tmpvar_53 = ((tmpvar_49 * (
    (0.3183099 * tmpvar_51)
   / 
    ((tmpvar_52 * tmpvar_52) + 1e-7)
  )) * 3.141593);
  specularTerm_31 = tmpvar_53;
  mediump float tmpvar_54;
  tmpvar_54 = max (0.0, (sqrt(
    max (0.0001, specularTerm_31)
  ) * tmpvar_38));
  specularTerm_31 = tmpvar_54;
  bvec3 tmpvar_55;
  tmpvar_55 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_56;
  tmpvar_56 = any(tmpvar_55);
  highp float tmpvar_57;
  if (tmpvar_56) {
    tmpvar_57 = 1.0;
  } else {
    tmpvar_57 = 0.0;
  };
  specularTerm_31 = (tmpvar_54 * tmpvar_57);
  mediump float x_58;
  x_58 = (1.0 - tmpvar_41);
  mediump vec4 tmpvar_59;
  tmpvar_59.w = 1.0;
  tmpvar_59.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_47)) + ((specularTerm_31 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_58 * x_58) * ((x_58 * x_58) * x_58)))
  )));
  mediump vec4 tmpvar_60;
  tmpvar_60 = exp2(-(tmpvar_59));
  tmpvar_1 = tmpvar_60;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
bool u_xlatb8;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_15;
mediump float u_xlat16_16;
float u_xlat17;
lowp float u_xlat10_17;
mediump float u_xlat16_20;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = max(abs(u_xlat8.y), abs(u_xlat8.x));
    u_xlat17 = max(abs(u_xlat8.z), u_xlat17);
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.z);
    u_xlat17 = max(u_xlat17, 9.99999975e-06);
    u_xlat17 = u_xlat17 * _LightProjectionParams.w;
    u_xlat17 = _LightProjectionParams.y / u_xlat17;
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.x);
    vec4 txVec0 = vec4(u_xlat8.xyz,u_xlat17);
    u_xlat10_17 = texture(hlslcc_zcmp_ShadowMapTexture, txVec0);
    u_xlat16_4.x = (-_LightShadowData.x) + 1.0;
    u_xlat16_4.x = u_xlat10_17 * u_xlat16_4.x + _LightShadowData.x;
    u_xlat16_12 = (-u_xlat16_4.x) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_12 + u_xlat16_4.x;
    u_xlat0.x = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat17 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat17)).x;
    u_xlat17 = u_xlat16_4.x * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat17) * _LightColor.xyz;
    u_xlat17 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat2.xyz = vec3(u_xlat17) * u_xlat2.xyz;
    u_xlat5.xyz = (-u_xlat8.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat24 = dot(u_xlat5.xyz, u_xlat5.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat5.xyz = vec3(u_xlat24) * u_xlat5.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_6.xyz = vec3(u_xlat16_24) * u_xlat16_6.xyz;
    u_xlat24 = dot(u_xlat16_6.xyz, u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-u_xlat0.xyz), u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.x = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat5.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat5.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_4.x = (-u_xlat16_26) + 1.0;
    u_xlat16_12 = abs(u_xlat8.x) * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = abs(u_xlat8.x) * u_xlat16_4.x;
    u_xlat16_20 = -abs(u_xlat8.x) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_12 + u_xlat16_4.x;
    u_xlat16_8 = u_xlat16_4.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8.x = u_xlat24 * u_xlat16_8;
    u_xlat8.x = u_xlat8.x * 3.14159274;
    u_xlat8.x = max(u_xlat8.x, 9.99999975e-05);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat16_4.x = u_xlat0.x * u_xlat8.x;
    u_xlat16_12 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb8 = u_xlat16_12!=0.0;
#endif
    u_xlat8.x = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_4.x = u_xlat8.x * u_xlat16_4.x;
    u_xlat16_4.xyw = u_xlat3.xyz * u_xlat16_4.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_4.xyw = u_xlat16_4.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_20 * u_xlat16_20;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_20 = u_xlat16_7.x * u_xlat16_20 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_20 = u_xlat0.x * u_xlat16_20;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_20);
    u_xlat16_0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_4.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.x;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = mix (dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)), 1.0, tmpvar_15);
  atten_6 = (tmpvar_14.x * tmpvar_38);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_41;
  mediump float tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_42 = gbuffer1_3.w;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_43 = tmpvar_44;
  highp vec3 viewDir_45;
  viewDir_45 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_46;
  mediump float nv_47;
  highp float tmpvar_48;
  highp float smoothness_49;
  smoothness_49 = tmpvar_42;
  tmpvar_48 = (1.0 - smoothness_49);
  highp vec3 tmpvar_50;
  highp vec3 inVec_51;
  inVec_51 = (lightDir_7 + viewDir_45);
  tmpvar_50 = (inVec_51 * inversesqrt(max (0.001, 
    dot (inVec_51, inVec_51)
  )));
  highp float tmpvar_52;
  tmpvar_52 = abs(dot (tmpvar_43, viewDir_45));
  nv_47 = tmpvar_52;
  mediump float tmpvar_53;
  highp float tmpvar_54;
  tmpvar_54 = clamp (dot (tmpvar_43, lightDir_7), 0.0, 1.0);
  tmpvar_53 = tmpvar_54;
  highp float tmpvar_55;
  tmpvar_55 = clamp (dot (tmpvar_43, tmpvar_50), 0.0, 1.0);
  mediump float tmpvar_56;
  highp float tmpvar_57;
  tmpvar_57 = clamp (dot (lightDir_7, tmpvar_50), 0.0, 1.0);
  tmpvar_56 = tmpvar_57;
  mediump float perceptualRoughness_58;
  perceptualRoughness_58 = tmpvar_48;
  mediump float tmpvar_59;
  tmpvar_59 = (0.5 + ((2.0 * tmpvar_56) * (tmpvar_56 * perceptualRoughness_58)));
  mediump float x_60;
  x_60 = (1.0 - tmpvar_53);
  mediump float x_61;
  x_61 = (1.0 - nv_47);
  mediump float tmpvar_62;
  tmpvar_62 = (((1.0 + 
    ((tmpvar_59 - 1.0) * ((x_60 * x_60) * ((x_60 * x_60) * x_60)))
  ) * (1.0 + 
    ((tmpvar_59 - 1.0) * ((x_61 * x_61) * ((x_61 * x_61) * x_61)))
  )) * tmpvar_53);
  highp float tmpvar_63;
  tmpvar_63 = max ((tmpvar_48 * tmpvar_48), 0.002);
  mediump float tmpvar_64;
  mediump float roughness_65;
  roughness_65 = tmpvar_63;
  tmpvar_64 = (0.5 / ((
    (tmpvar_53 * ((nv_47 * (1.0 - roughness_65)) + roughness_65))
   + 
    (nv_47 * ((tmpvar_53 * (1.0 - roughness_65)) + roughness_65))
  ) + 1e-5));
  highp float tmpvar_66;
  tmpvar_66 = (tmpvar_63 * tmpvar_63);
  highp float tmpvar_67;
  tmpvar_67 = (((
    (tmpvar_55 * tmpvar_66)
   - tmpvar_55) * tmpvar_55) + 1.0);
  highp float tmpvar_68;
  tmpvar_68 = ((tmpvar_64 * (
    (0.3183099 * tmpvar_66)
   / 
    ((tmpvar_67 * tmpvar_67) + 1e-7)
  )) * 3.141593);
  specularTerm_46 = tmpvar_68;
  mediump float tmpvar_69;
  tmpvar_69 = max (0.0, (sqrt(
    max (0.0001, specularTerm_46)
  ) * tmpvar_53));
  specularTerm_46 = tmpvar_69;
  bvec3 tmpvar_70;
  tmpvar_70 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_71;
  tmpvar_71 = any(tmpvar_70);
  highp float tmpvar_72;
  if (tmpvar_71) {
    tmpvar_72 = 1.0;
  } else {
    tmpvar_72 = 0.0;
  };
  specularTerm_46 = (tmpvar_69 * tmpvar_72);
  mediump float x_73;
  x_73 = (1.0 - tmpvar_56);
  mediump vec4 tmpvar_74;
  tmpvar_74.w = 1.0;
  tmpvar_74.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_62)) + ((specularTerm_46 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_73 * x_73) * ((x_73 * x_73) * x_73)))
  )));
  mediump vec4 tmpvar_75;
  tmpvar_75 = exp2(-(tmpvar_74));
  tmpvar_1 = tmpvar_75;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec3 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
bool u_xlatb8;
mediump float u_xlat16_13;
mediump vec3 u_xlat16_15;
mediump float u_xlat16_16;
float u_xlat17;
mediump float u_xlat16_21;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = max(abs(u_xlat8.y), abs(u_xlat8.x));
    u_xlat17 = max(abs(u_xlat8.z), u_xlat17);
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.z);
    u_xlat17 = max(u_xlat17, 9.99999975e-06);
    u_xlat17 = u_xlat17 * _LightProjectionParams.w;
    u_xlat17 = _LightProjectionParams.y / u_xlat17;
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.x);
    u_xlat3.xyz = u_xlat8.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    vec4 txVec0 = vec4(u_xlat3.xyz,u_xlat17);
    u_xlat3.x = texture(hlslcc_zcmp_ShadowMapTexture, txVec0);
    u_xlat4.xyz = u_xlat8.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    vec4 txVec1 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.y = texture(hlslcc_zcmp_ShadowMapTexture, txVec1);
    u_xlat4.xyz = u_xlat8.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    vec4 txVec2 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.z = texture(hlslcc_zcmp_ShadowMapTexture, txVec2);
    u_xlat4.xyz = u_xlat8.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    vec4 txVec3 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.w = texture(hlslcc_zcmp_ShadowMapTexture, txVec3);
    u_xlat17 = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_5.x = (-_LightShadowData.x) + 1.0;
    u_xlat16_5.x = u_xlat17 * u_xlat16_5.x + _LightShadowData.x;
    u_xlat16_13 = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_13 + u_xlat16_5.x;
    u_xlat0.x = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat17 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat17)).x;
    u_xlat17 = u_xlat16_5.x * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat17) * _LightColor.xyz;
    u_xlat17 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat2.xyz = vec3(u_xlat17) * u_xlat2.xyz;
    u_xlat4.xyz = (-u_xlat8.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_6.xyz = vec3(u_xlat16_24) * u_xlat16_6.xyz;
    u_xlat24 = dot(u_xlat16_6.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-u_xlat0.xyz), u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.x = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat4.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat4.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_5.x = (-u_xlat16_26) + 1.0;
    u_xlat16_13 = abs(u_xlat8.x) * u_xlat16_5.x + u_xlat16_26;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_5.x + u_xlat16_26;
    u_xlat16_5.x = abs(u_xlat8.x) * u_xlat16_5.x;
    u_xlat16_21 = -abs(u_xlat8.x) + 1.0;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_13 + u_xlat16_5.x;
    u_xlat16_8 = u_xlat16_5.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8.x = u_xlat24 * u_xlat16_8;
    u_xlat8.x = u_xlat8.x * 3.14159274;
    u_xlat8.x = max(u_xlat8.x, 9.99999975e-05);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat16_5.x = u_xlat0.x * u_xlat8.x;
    u_xlat16_13 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_13!=0.0);
#else
    u_xlatb8 = u_xlat16_13!=0.0;
#endif
    u_xlat8.x = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_5.x = u_xlat8.x * u_xlat16_5.x;
    u_xlat16_5.xyw = u_xlat3.xyz * u_xlat16_5.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_5.xyw = u_xlat16_5.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_21 * u_xlat16_21;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_21 = u_xlat16_7.x * u_xlat16_21 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_7.x;
    u_xlat16_21 = u_xlat0.x * u_xlat16_21;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_21);
    u_xlat16_0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_5.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.x;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = mix (tmpvar_22, 1.0, tmpvar_15);
  atten_6 = (tmpvar_14.x * tmpvar_23);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25.w = -8.0;
  tmpvar_25.xyz = (unity_WorldToLight * tmpvar_24).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_25.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump float tmpvar_29;
  highp vec3 tmpvar_30;
  tmpvar_29 = gbuffer1_3.w;
  mediump vec3 tmpvar_31;
  tmpvar_31 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_30 = tmpvar_31;
  highp vec3 viewDir_32;
  viewDir_32 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_33;
  mediump float nv_34;
  highp float tmpvar_35;
  highp float smoothness_36;
  smoothness_36 = tmpvar_29;
  tmpvar_35 = (1.0 - smoothness_36);
  highp vec3 tmpvar_37;
  highp vec3 inVec_38;
  inVec_38 = (lightDir_7 + viewDir_32);
  tmpvar_37 = (inVec_38 * inversesqrt(max (0.001, 
    dot (inVec_38, inVec_38)
  )));
  highp float tmpvar_39;
  tmpvar_39 = abs(dot (tmpvar_30, viewDir_32));
  nv_34 = tmpvar_39;
  mediump float tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_30, lightDir_7), 0.0, 1.0);
  tmpvar_40 = tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = clamp (dot (tmpvar_30, tmpvar_37), 0.0, 1.0);
  mediump float tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = clamp (dot (lightDir_7, tmpvar_37), 0.0, 1.0);
  tmpvar_43 = tmpvar_44;
  mediump float perceptualRoughness_45;
  perceptualRoughness_45 = tmpvar_35;
  mediump float tmpvar_46;
  tmpvar_46 = (0.5 + ((2.0 * tmpvar_43) * (tmpvar_43 * perceptualRoughness_45)));
  mediump float x_47;
  x_47 = (1.0 - tmpvar_40);
  mediump float x_48;
  x_48 = (1.0 - nv_34);
  mediump float tmpvar_49;
  tmpvar_49 = (((1.0 + 
    ((tmpvar_46 - 1.0) * ((x_47 * x_47) * ((x_47 * x_47) * x_47)))
  ) * (1.0 + 
    ((tmpvar_46 - 1.0) * ((x_48 * x_48) * ((x_48 * x_48) * x_48)))
  )) * tmpvar_40);
  highp float tmpvar_50;
  tmpvar_50 = max ((tmpvar_35 * tmpvar_35), 0.002);
  mediump float tmpvar_51;
  mediump float roughness_52;
  roughness_52 = tmpvar_50;
  tmpvar_51 = (0.5 / ((
    (tmpvar_40 * ((nv_34 * (1.0 - roughness_52)) + roughness_52))
   + 
    (nv_34 * ((tmpvar_40 * (1.0 - roughness_52)) + roughness_52))
  ) + 1e-5));
  highp float tmpvar_53;
  tmpvar_53 = (tmpvar_50 * tmpvar_50);
  highp float tmpvar_54;
  tmpvar_54 = (((
    (tmpvar_42 * tmpvar_53)
   - tmpvar_42) * tmpvar_42) + 1.0);
  highp float tmpvar_55;
  tmpvar_55 = ((tmpvar_51 * (
    (0.3183099 * tmpvar_53)
   / 
    ((tmpvar_54 * tmpvar_54) + 1e-7)
  )) * 3.141593);
  specularTerm_33 = tmpvar_55;
  mediump float tmpvar_56;
  tmpvar_56 = max (0.0, (sqrt(
    max (0.0001, specularTerm_33)
  ) * tmpvar_40));
  specularTerm_33 = tmpvar_56;
  bvec3 tmpvar_57;
  tmpvar_57 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_58;
  tmpvar_58 = any(tmpvar_57);
  highp float tmpvar_59;
  if (tmpvar_58) {
    tmpvar_59 = 1.0;
  } else {
    tmpvar_59 = 0.0;
  };
  specularTerm_33 = (tmpvar_56 * tmpvar_59);
  mediump float x_60;
  x_60 = (1.0 - tmpvar_43);
  mediump vec4 tmpvar_61;
  tmpvar_61.w = 1.0;
  tmpvar_61.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_49)) + ((specularTerm_33 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_60 * x_60) * ((x_60 * x_60) * x_60)))
  )));
  mediump vec4 tmpvar_62;
  tmpvar_62 = exp2(-(tmpvar_61));
  tmpvar_1 = tmpvar_62;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
bool u_xlatb8;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_15;
mediump float u_xlat16_16;
float u_xlat17;
lowp float u_xlat10_17;
mediump float u_xlat16_20;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat17 = max(abs(u_xlat8.y), abs(u_xlat8.x));
    u_xlat17 = max(abs(u_xlat8.z), u_xlat17);
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.z);
    u_xlat17 = max(u_xlat17, 9.99999975e-06);
    u_xlat17 = u_xlat17 * _LightProjectionParams.w;
    u_xlat17 = _LightProjectionParams.y / u_xlat17;
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.x);
    vec4 txVec0 = vec4(u_xlat8.xyz,u_xlat17);
    u_xlat10_17 = texture(hlslcc_zcmp_ShadowMapTexture, txVec0);
    u_xlat16_4.x = (-_LightShadowData.x) + 1.0;
    u_xlat16_4.x = u_xlat10_17 * u_xlat16_4.x + _LightShadowData.x;
    u_xlat16_12 = (-u_xlat16_4.x) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_12 + u_xlat16_4.x;
    u_xlat0.x = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat17 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat17)).x;
    u_xlat17 = u_xlat16_4.x * u_xlat17;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat25 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat17 = u_xlat25 * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat17) * _LightColor.xyz;
    u_xlat17 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat2.xyz = vec3(u_xlat17) * u_xlat2.xyz;
    u_xlat5.xyz = (-u_xlat8.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat24 = dot(u_xlat5.xyz, u_xlat5.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat5.xyz = vec3(u_xlat24) * u_xlat5.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_6.xyz = vec3(u_xlat16_24) * u_xlat16_6.xyz;
    u_xlat24 = dot(u_xlat16_6.xyz, u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-u_xlat0.xyz), u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.x = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat5.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat5.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_4.x = (-u_xlat16_26) + 1.0;
    u_xlat16_12 = abs(u_xlat8.x) * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = abs(u_xlat8.x) * u_xlat16_4.x;
    u_xlat16_20 = -abs(u_xlat8.x) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_12 + u_xlat16_4.x;
    u_xlat16_8 = u_xlat16_4.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8.x = u_xlat24 * u_xlat16_8;
    u_xlat8.x = u_xlat8.x * 3.14159274;
    u_xlat8.x = max(u_xlat8.x, 9.99999975e-05);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat16_4.x = u_xlat0.x * u_xlat8.x;
    u_xlat16_12 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb8 = u_xlat16_12!=0.0;
#endif
    u_xlat8.x = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_4.x = u_xlat8.x * u_xlat16_4.x;
    u_xlat16_4.xyw = u_xlat3.xyz * u_xlat16_4.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_4.xyw = u_xlat16_4.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_20 * u_xlat16_20;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_20 = u_xlat16_7.x * u_xlat16_20 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_20 = u_xlat0.x * u_xlat16_20;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_20);
    u_xlat16_0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_4.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.x;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = mix (dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)), 1.0, tmpvar_15);
  atten_6 = (tmpvar_14.x * tmpvar_38);
  highp vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = tmpvar_10;
  highp vec4 tmpvar_40;
  tmpvar_40.w = -8.0;
  tmpvar_40.xyz = (unity_WorldToLight * tmpvar_39).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_40.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_42;
  lowp vec4 tmpvar_43;
  tmpvar_43 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_43;
  mediump float tmpvar_44;
  highp vec3 tmpvar_45;
  tmpvar_44 = gbuffer1_3.w;
  mediump vec3 tmpvar_46;
  tmpvar_46 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  tmpvar_45 = tmpvar_46;
  highp vec3 viewDir_47;
  viewDir_47 = -(normalize((tmpvar_10 - _WorldSpaceCameraPos)));
  mediump float specularTerm_48;
  mediump float nv_49;
  highp float tmpvar_50;
  highp float smoothness_51;
  smoothness_51 = tmpvar_44;
  tmpvar_50 = (1.0 - smoothness_51);
  highp vec3 tmpvar_52;
  highp vec3 inVec_53;
  inVec_53 = (lightDir_7 + viewDir_47);
  tmpvar_52 = (inVec_53 * inversesqrt(max (0.001, 
    dot (inVec_53, inVec_53)
  )));
  highp float tmpvar_54;
  tmpvar_54 = abs(dot (tmpvar_45, viewDir_47));
  nv_49 = tmpvar_54;
  mediump float tmpvar_55;
  highp float tmpvar_56;
  tmpvar_56 = clamp (dot (tmpvar_45, lightDir_7), 0.0, 1.0);
  tmpvar_55 = tmpvar_56;
  highp float tmpvar_57;
  tmpvar_57 = clamp (dot (tmpvar_45, tmpvar_52), 0.0, 1.0);
  mediump float tmpvar_58;
  highp float tmpvar_59;
  tmpvar_59 = clamp (dot (lightDir_7, tmpvar_52), 0.0, 1.0);
  tmpvar_58 = tmpvar_59;
  mediump float perceptualRoughness_60;
  perceptualRoughness_60 = tmpvar_50;
  mediump float tmpvar_61;
  tmpvar_61 = (0.5 + ((2.0 * tmpvar_58) * (tmpvar_58 * perceptualRoughness_60)));
  mediump float x_62;
  x_62 = (1.0 - tmpvar_55);
  mediump float x_63;
  x_63 = (1.0 - nv_49);
  mediump float tmpvar_64;
  tmpvar_64 = (((1.0 + 
    ((tmpvar_61 - 1.0) * ((x_62 * x_62) * ((x_62 * x_62) * x_62)))
  ) * (1.0 + 
    ((tmpvar_61 - 1.0) * ((x_63 * x_63) * ((x_63 * x_63) * x_63)))
  )) * tmpvar_55);
  highp float tmpvar_65;
  tmpvar_65 = max ((tmpvar_50 * tmpvar_50), 0.002);
  mediump float tmpvar_66;
  mediump float roughness_67;
  roughness_67 = tmpvar_65;
  tmpvar_66 = (0.5 / ((
    (tmpvar_55 * ((nv_49 * (1.0 - roughness_67)) + roughness_67))
   + 
    (nv_49 * ((tmpvar_55 * (1.0 - roughness_67)) + roughness_67))
  ) + 1e-5));
  highp float tmpvar_68;
  tmpvar_68 = (tmpvar_65 * tmpvar_65);
  highp float tmpvar_69;
  tmpvar_69 = (((
    (tmpvar_57 * tmpvar_68)
   - tmpvar_57) * tmpvar_57) + 1.0);
  highp float tmpvar_70;
  tmpvar_70 = ((tmpvar_66 * (
    (0.3183099 * tmpvar_68)
   / 
    ((tmpvar_69 * tmpvar_69) + 1e-7)
  )) * 3.141593);
  specularTerm_48 = tmpvar_70;
  mediump float tmpvar_71;
  tmpvar_71 = max (0.0, (sqrt(
    max (0.0001, specularTerm_48)
  ) * tmpvar_55));
  specularTerm_48 = tmpvar_71;
  bvec3 tmpvar_72;
  tmpvar_72 = bvec3(gbuffer1_3.xyz);
  bool tmpvar_73;
  tmpvar_73 = any(tmpvar_72);
  highp float tmpvar_74;
  if (tmpvar_73) {
    tmpvar_74 = 1.0;
  } else {
    tmpvar_74 = 0.0;
  };
  specularTerm_48 = (tmpvar_71 * tmpvar_74);
  mediump float x_75;
  x_75 = (1.0 - tmpvar_58);
  mediump vec4 tmpvar_76;
  tmpvar_76.w = 1.0;
  tmpvar_76.xyz = ((gbuffer0_4.xyz * (tmpvar_5 * tmpvar_64)) + ((specularTerm_48 * tmpvar_5) * (gbuffer1_3.xyz + 
    ((1.0 - gbuffer1_3.xyz) * ((x_75 * x_75) * ((x_75 * x_75) * x_75)))
  )));
  mediump vec4 tmpvar_77;
  tmpvar_77 = exp2(-(tmpvar_76));
  tmpvar_1 = tmpvar_77;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec3 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
bool u_xlatb8;
mediump float u_xlat16_13;
mediump vec3 u_xlat16_15;
mediump float u_xlat16_16;
float u_xlat17;
mediump float u_xlat16_21;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat17 = max(abs(u_xlat8.y), abs(u_xlat8.x));
    u_xlat17 = max(abs(u_xlat8.z), u_xlat17);
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.z);
    u_xlat17 = max(u_xlat17, 9.99999975e-06);
    u_xlat17 = u_xlat17 * _LightProjectionParams.w;
    u_xlat17 = _LightProjectionParams.y / u_xlat17;
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.x);
    u_xlat3.xyz = u_xlat8.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    vec4 txVec0 = vec4(u_xlat3.xyz,u_xlat17);
    u_xlat3.x = texture(hlslcc_zcmp_ShadowMapTexture, txVec0);
    u_xlat4.xyz = u_xlat8.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    vec4 txVec1 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.y = texture(hlslcc_zcmp_ShadowMapTexture, txVec1);
    u_xlat4.xyz = u_xlat8.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    vec4 txVec2 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.z = texture(hlslcc_zcmp_ShadowMapTexture, txVec2);
    u_xlat4.xyz = u_xlat8.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    vec4 txVec3 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.w = texture(hlslcc_zcmp_ShadowMapTexture, txVec3);
    u_xlat17 = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_5.x = (-_LightShadowData.x) + 1.0;
    u_xlat16_5.x = u_xlat17 * u_xlat16_5.x + _LightShadowData.x;
    u_xlat16_13 = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_13 + u_xlat16_5.x;
    u_xlat0.x = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat17 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat17)).x;
    u_xlat17 = u_xlat16_5.x * u_xlat17;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat25 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat17 = u_xlat25 * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat17) * _LightColor.xyz;
    u_xlat17 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat2.xyz = vec3(u_xlat17) * u_xlat2.xyz;
    u_xlat4.xyz = (-u_xlat8.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_6.xyz = vec3(u_xlat16_24) * u_xlat16_6.xyz;
    u_xlat24 = dot(u_xlat16_6.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-u_xlat0.xyz), u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.x = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat4.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat4.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_5.x = (-u_xlat16_26) + 1.0;
    u_xlat16_13 = abs(u_xlat8.x) * u_xlat16_5.x + u_xlat16_26;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_5.x + u_xlat16_26;
    u_xlat16_5.x = abs(u_xlat8.x) * u_xlat16_5.x;
    u_xlat16_21 = -abs(u_xlat8.x) + 1.0;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_13 + u_xlat16_5.x;
    u_xlat16_8 = u_xlat16_5.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8.x = u_xlat24 * u_xlat16_8;
    u_xlat8.x = u_xlat8.x * 3.14159274;
    u_xlat8.x = max(u_xlat8.x, 9.99999975e-05);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat16_5.x = u_xlat0.x * u_xlat8.x;
    u_xlat16_13 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_13!=0.0);
#else
    u_xlatb8 = u_xlat16_13!=0.0;
#endif
    u_xlat8.x = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_5.x = u_xlat8.x * u_xlat16_5.x;
    u_xlat16_5.xyw = u_xlat3.xyz * u_xlat16_5.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_5.xyw = u_xlat16_5.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_21 * u_xlat16_21;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_21 = u_xlat16_7.x * u_xlat16_21 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_7.x;
    u_xlat16_21 = u_xlat0.x * u_xlat16_21;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_21);
    u_xlat16_0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_5.xyw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).x;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_14;
  mediump float tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_15 = gbuffer1_2.w;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_16 = tmpvar_17;
  highp vec3 viewDir_18;
  viewDir_18 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_19;
  mediump float nv_20;
  highp float tmpvar_21;
  highp float smoothness_22;
  smoothness_22 = tmpvar_15;
  tmpvar_21 = (1.0 - smoothness_22);
  highp vec3 tmpvar_23;
  highp vec3 inVec_24;
  inVec_24 = (lightDir_6 + viewDir_18);
  tmpvar_23 = (inVec_24 * inversesqrt(max (0.001, 
    dot (inVec_24, inVec_24)
  )));
  highp float tmpvar_25;
  tmpvar_25 = abs(dot (tmpvar_16, viewDir_18));
  nv_20 = tmpvar_25;
  mediump float tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_16, lightDir_6), 0.0, 1.0);
  tmpvar_26 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_16, tmpvar_23), 0.0, 1.0);
  mediump float tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (lightDir_6, tmpvar_23), 0.0, 1.0);
  tmpvar_29 = tmpvar_30;
  mediump float perceptualRoughness_31;
  perceptualRoughness_31 = tmpvar_21;
  mediump float tmpvar_32;
  tmpvar_32 = (0.5 + ((2.0 * tmpvar_29) * (tmpvar_29 * perceptualRoughness_31)));
  mediump float x_33;
  x_33 = (1.0 - tmpvar_26);
  mediump float x_34;
  x_34 = (1.0 - nv_20);
  mediump float tmpvar_35;
  tmpvar_35 = (((1.0 + 
    ((tmpvar_32 - 1.0) * ((x_33 * x_33) * ((x_33 * x_33) * x_33)))
  ) * (1.0 + 
    ((tmpvar_32 - 1.0) * ((x_34 * x_34) * ((x_34 * x_34) * x_34)))
  )) * tmpvar_26);
  highp float tmpvar_36;
  tmpvar_36 = max ((tmpvar_21 * tmpvar_21), 0.002);
  mediump float tmpvar_37;
  mediump float roughness_38;
  roughness_38 = tmpvar_36;
  tmpvar_37 = (0.5 / ((
    (tmpvar_26 * ((nv_20 * (1.0 - roughness_38)) + roughness_38))
   + 
    (nv_20 * ((tmpvar_26 * (1.0 - roughness_38)) + roughness_38))
  ) + 1e-5));
  highp float tmpvar_39;
  tmpvar_39 = (tmpvar_36 * tmpvar_36);
  highp float tmpvar_40;
  tmpvar_40 = (((
    (tmpvar_28 * tmpvar_39)
   - tmpvar_28) * tmpvar_28) + 1.0);
  highp float tmpvar_41;
  tmpvar_41 = ((tmpvar_37 * (
    (0.3183099 * tmpvar_39)
   / 
    ((tmpvar_40 * tmpvar_40) + 1e-7)
  )) * 3.141593);
  specularTerm_19 = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, (sqrt(
    max (0.0001, specularTerm_19)
  ) * tmpvar_26));
  specularTerm_19 = tmpvar_42;
  bvec3 tmpvar_43;
  tmpvar_43 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_44;
  tmpvar_44 = any(tmpvar_43);
  highp float tmpvar_45;
  if (tmpvar_44) {
    tmpvar_45 = 1.0;
  } else {
    tmpvar_45 = 0.0;
  };
  specularTerm_19 = (tmpvar_42 * tmpvar_45);
  mediump float x_46;
  x_46 = (1.0 - tmpvar_29);
  mediump vec4 tmpvar_47;
  tmpvar_47.w = 1.0;
  tmpvar_47.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_35)) + ((specularTerm_19 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_46 * x_46) * ((x_46 * x_46) * x_46)))
  )));
  gl_FragData[0] = tmpvar_47;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
lowp vec3 u_xlat10_5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat8;
mediump float u_xlat16_8;
bool u_xlatb8;
mediump float u_xlat16_14;
mediump vec3 u_xlat16_15;
mediump float u_xlat16_16;
float u_xlat17;
mediump float u_xlat16_22;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat24 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat17 = inversesqrt(u_xlat24);
    u_xlat24 = u_xlat24 * _LightPos.w;
    u_xlat24 = texture(_LightTextureB0, vec2(u_xlat24)).x;
    u_xlat3.xyz = vec3(u_xlat24) * _LightColor.xyz;
    u_xlat4.xyz = (-u_xlat0.xyz) * vec3(u_xlat17) + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat17);
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_5.xyz = vec3(u_xlat16_24) * u_xlat16_5.xyz;
    u_xlat24 = dot(u_xlat16_5.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-u_xlat0.xyz), u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_5.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat4.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat4.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_6.x = (-u_xlat16_26) + 1.0;
    u_xlat16_14 = abs(u_xlat8) * u_xlat16_6.x + u_xlat16_26;
    u_xlat16_6.x = u_xlat0.x * u_xlat16_6.x + u_xlat16_26;
    u_xlat16_6.x = abs(u_xlat8) * u_xlat16_6.x;
    u_xlat16_22 = -abs(u_xlat8) + 1.0;
    u_xlat16_6.x = u_xlat0.x * u_xlat16_14 + u_xlat16_6.x;
    u_xlat16_8 = u_xlat16_6.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8 = u_xlat24 * u_xlat16_8;
    u_xlat8 = u_xlat8 * 3.14159274;
    u_xlat8 = max(u_xlat8, 9.99999975e-05);
    u_xlat8 = sqrt(u_xlat8);
    u_xlat16_6.x = u_xlat0.x * u_xlat8;
    u_xlat16_14 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_14!=0.0);
#else
    u_xlatb8 = u_xlat16_14!=0.0;
#endif
    u_xlat8 = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_6.x = u_xlat8 * u_xlat16_6.x;
    u_xlat16_6.xyw = u_xlat3.xyz * u_xlat16_6.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_6.xyw = u_xlat16_6.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_22 = u_xlat16_7.x * u_xlat16_22 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_22 = u_xlat0.x * u_xlat16_22;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_22);
    SV_Target0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_6.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_8;
  tmpvar_4 = _LightColor.xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_11;
  mediump float tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_12 = gbuffer1_2.w;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_13 = tmpvar_14;
  highp vec3 viewDir_15;
  viewDir_15 = -(normalize((
    (unity_CameraToWorld * tmpvar_7)
  .xyz - _WorldSpaceCameraPos)));
  mediump float specularTerm_16;
  mediump float nv_17;
  highp float tmpvar_18;
  highp float smoothness_19;
  smoothness_19 = tmpvar_12;
  tmpvar_18 = (1.0 - smoothness_19);
  highp vec3 tmpvar_20;
  highp vec3 inVec_21;
  inVec_21 = (lightDir_5 + viewDir_15);
  tmpvar_20 = (inVec_21 * inversesqrt(max (0.001, 
    dot (inVec_21, inVec_21)
  )));
  highp float tmpvar_22;
  tmpvar_22 = abs(dot (tmpvar_13, viewDir_15));
  nv_17 = tmpvar_22;
  mediump float tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_13, lightDir_5), 0.0, 1.0);
  tmpvar_23 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_13, tmpvar_20), 0.0, 1.0);
  mediump float tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = clamp (dot (lightDir_5, tmpvar_20), 0.0, 1.0);
  tmpvar_26 = tmpvar_27;
  mediump float perceptualRoughness_28;
  perceptualRoughness_28 = tmpvar_18;
  mediump float tmpvar_29;
  tmpvar_29 = (0.5 + ((2.0 * tmpvar_26) * (tmpvar_26 * perceptualRoughness_28)));
  mediump float x_30;
  x_30 = (1.0 - tmpvar_23);
  mediump float x_31;
  x_31 = (1.0 - nv_17);
  mediump float tmpvar_32;
  tmpvar_32 = (((1.0 + 
    ((tmpvar_29 - 1.0) * ((x_30 * x_30) * ((x_30 * x_30) * x_30)))
  ) * (1.0 + 
    ((tmpvar_29 - 1.0) * ((x_31 * x_31) * ((x_31 * x_31) * x_31)))
  )) * tmpvar_23);
  highp float tmpvar_33;
  tmpvar_33 = max ((tmpvar_18 * tmpvar_18), 0.002);
  mediump float tmpvar_34;
  mediump float roughness_35;
  roughness_35 = tmpvar_33;
  tmpvar_34 = (0.5 / ((
    (tmpvar_23 * ((nv_17 * (1.0 - roughness_35)) + roughness_35))
   + 
    (nv_17 * ((tmpvar_23 * (1.0 - roughness_35)) + roughness_35))
  ) + 1e-5));
  highp float tmpvar_36;
  tmpvar_36 = (tmpvar_33 * tmpvar_33);
  highp float tmpvar_37;
  tmpvar_37 = (((
    (tmpvar_25 * tmpvar_36)
   - tmpvar_25) * tmpvar_25) + 1.0);
  highp float tmpvar_38;
  tmpvar_38 = ((tmpvar_34 * (
    (0.3183099 * tmpvar_36)
   / 
    ((tmpvar_37 * tmpvar_37) + 1e-7)
  )) * 3.141593);
  specularTerm_16 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = max (0.0, (sqrt(
    max (0.0001, specularTerm_16)
  ) * tmpvar_23));
  specularTerm_16 = tmpvar_39;
  bvec3 tmpvar_40;
  tmpvar_40 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_41;
  tmpvar_41 = any(tmpvar_40);
  highp float tmpvar_42;
  if (tmpvar_41) {
    tmpvar_42 = 1.0;
  } else {
    tmpvar_42 = 0.0;
  };
  specularTerm_16 = (tmpvar_39 * tmpvar_42);
  mediump float x_43;
  x_43 = (1.0 - tmpvar_26);
  mediump vec4 tmpvar_44;
  tmpvar_44.w = 1.0;
  tmpvar_44.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_32)) + ((specularTerm_16 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_43 * x_43) * ((x_43 * x_43) * x_43)))
  )));
  gl_FragData[0] = tmpvar_44;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
lowp vec3 u_xlat10_3;
mediump float u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
float u_xlat11;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_19;
mediump float u_xlat16_20;
float u_xlat21;
mediump float u_xlat16_21;
mediump float u_xlat16_23;
mediump float u_xlat16_24;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat21 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat0.xyz) * vec3(u_xlat21) + (-_LightDir.xyz);
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = max(u_xlat21, 0.00100000005);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_3.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_21 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_21 = inversesqrt(u_xlat16_21);
    u_xlat16_3.xyz = vec3(u_xlat16_21) * u_xlat16_3.xyz;
    u_xlat21 = dot(u_xlat16_3.xyz, u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat21 = min(max(u_xlat21, 0.0), 1.0);
#else
    u_xlat21 = clamp(u_xlat21, 0.0, 1.0);
#endif
    u_xlat15 = dot((-_LightDir.xyz), u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat15 = min(max(u_xlat15, 0.0), 1.0);
#else
    u_xlat15 = clamp(u_xlat15, 0.0, 1.0);
#endif
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_23 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_24 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_24 = max(u_xlat16_24, 0.00200000009);
    u_xlat16_4 = u_xlat16_24 * u_xlat16_24;
    u_xlat11 = u_xlat21 * u_xlat16_4 + (-u_xlat21);
    u_xlat21 = u_xlat11 * u_xlat21 + 1.0;
    u_xlat21 = u_xlat21 * u_xlat21 + 1.00000001e-07;
    u_xlat16_4 = u_xlat16_4 * 0.318309873;
    u_xlat21 = u_xlat16_4 / u_xlat21;
    u_xlat0.x = dot(u_xlat16_3.xyz, (-u_xlat0.xyz));
    u_xlat7 = dot(u_xlat16_3.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat16_5.x = (-u_xlat16_24) + 1.0;
    u_xlat16_12 = abs(u_xlat0.x) * u_xlat16_5.x + u_xlat16_24;
    u_xlat16_5.x = u_xlat7 * u_xlat16_5.x + u_xlat16_24;
    u_xlat16_5.x = abs(u_xlat0.x) * u_xlat16_5.x;
    u_xlat16_19 = -abs(u_xlat0.x) + 1.0;
    u_xlat16_5.x = u_xlat7 * u_xlat16_12 + u_xlat16_5.x;
    u_xlat16_0 = u_xlat16_5.x + 9.99999975e-06;
    u_xlat16_0 = 0.5 / u_xlat16_0;
    u_xlat0.x = u_xlat21 * u_xlat16_0;
    u_xlat0.x = u_xlat0.x * 3.14159274;
    u_xlat0.x = max(u_xlat0.x, 9.99999975e-05);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat16_5.x = u_xlat7 * u_xlat0.x;
    u_xlat16_12 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb0 = u_xlat16_12!=0.0;
#endif
    u_xlat0.x = u_xlatb0 ? 1.0 : float(0.0);
    u_xlat16_5.x = u_xlat0.x * u_xlat16_5.x;
    u_xlat16_5.xyw = u_xlat16_5.xxx * _LightColor.xyz;
    u_xlat16_6.x = (-u_xlat15) + 1.0;
    u_xlat16_13.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_13.x;
    u_xlat16_13.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_6.xyz = u_xlat16_13.xyz * u_xlat16_6.xxx + u_xlat10_2.xyz;
    u_xlat16_5.xyw = u_xlat16_5.xyw * u_xlat16_6.xyz;
    u_xlat16_6.x = u_xlat15 + u_xlat15;
    u_xlat16_6.x = u_xlat15 * u_xlat16_6.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_23 + -0.5;
    u_xlat16_13.x = u_xlat16_19 * u_xlat16_19;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_19 = u_xlat16_19 * u_xlat16_13.x;
    u_xlat16_19 = u_xlat16_6.x * u_xlat16_19 + 1.0;
    u_xlat16_13.x = (-u_xlat7) + 1.0;
    u_xlat16_20 = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_20;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_20;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_13.x + 1.0;
    u_xlat16_19 = u_xlat16_19 * u_xlat16_6.x;
    u_xlat16_19 = u_xlat7 * u_xlat16_19;
    u_xlat16_6.xyz = vec3(u_xlat16_19) * _LightColor.xyz;
    SV_Target0.xyz = u_xlat10_1.xyw * u_xlat16_6.xyz + u_xlat16_5.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(tmpvar_10);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13 = (unity_WorldToLight * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (tmpvar_13.xy / tmpvar_13.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w * float((tmpvar_13.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).x);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  mediump float tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_18 = gbuffer1_2.w;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_19 = tmpvar_20;
  highp vec3 viewDir_21;
  viewDir_21 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_22;
  mediump float nv_23;
  highp float tmpvar_24;
  highp float smoothness_25;
  smoothness_25 = tmpvar_18;
  tmpvar_24 = (1.0 - smoothness_25);
  highp vec3 tmpvar_26;
  highp vec3 inVec_27;
  inVec_27 = (lightDir_6 + viewDir_21);
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  highp float tmpvar_28;
  tmpvar_28 = abs(dot (tmpvar_19, viewDir_21));
  nv_23 = tmpvar_28;
  mediump float tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_19, lightDir_6), 0.0, 1.0);
  tmpvar_29 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (dot (tmpvar_19, tmpvar_26), 0.0, 1.0);
  mediump float tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp (dot (lightDir_6, tmpvar_26), 0.0, 1.0);
  tmpvar_32 = tmpvar_33;
  mediump float perceptualRoughness_34;
  perceptualRoughness_34 = tmpvar_24;
  mediump float tmpvar_35;
  tmpvar_35 = (0.5 + ((2.0 * tmpvar_32) * (tmpvar_32 * perceptualRoughness_34)));
  mediump float x_36;
  x_36 = (1.0 - tmpvar_29);
  mediump float x_37;
  x_37 = (1.0 - nv_23);
  mediump float tmpvar_38;
  tmpvar_38 = (((1.0 + 
    ((tmpvar_35 - 1.0) * ((x_36 * x_36) * ((x_36 * x_36) * x_36)))
  ) * (1.0 + 
    ((tmpvar_35 - 1.0) * ((x_37 * x_37) * ((x_37 * x_37) * x_37)))
  )) * tmpvar_29);
  highp float tmpvar_39;
  tmpvar_39 = max ((tmpvar_24 * tmpvar_24), 0.002);
  mediump float tmpvar_40;
  mediump float roughness_41;
  roughness_41 = tmpvar_39;
  tmpvar_40 = (0.5 / ((
    (tmpvar_29 * ((nv_23 * (1.0 - roughness_41)) + roughness_41))
   + 
    (nv_23 * ((tmpvar_29 * (1.0 - roughness_41)) + roughness_41))
  ) + 1e-5));
  highp float tmpvar_42;
  tmpvar_42 = (tmpvar_39 * tmpvar_39);
  highp float tmpvar_43;
  tmpvar_43 = (((
    (tmpvar_31 * tmpvar_42)
   - tmpvar_31) * tmpvar_31) + 1.0);
  highp float tmpvar_44;
  tmpvar_44 = ((tmpvar_40 * (
    (0.3183099 * tmpvar_42)
   / 
    ((tmpvar_43 * tmpvar_43) + 1e-7)
  )) * 3.141593);
  specularTerm_22 = tmpvar_44;
  mediump float tmpvar_45;
  tmpvar_45 = max (0.0, (sqrt(
    max (0.0001, specularTerm_22)
  ) * tmpvar_29));
  specularTerm_22 = tmpvar_45;
  bvec3 tmpvar_46;
  tmpvar_46 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_47;
  tmpvar_47 = any(tmpvar_46);
  highp float tmpvar_48;
  if (tmpvar_47) {
    tmpvar_48 = 1.0;
  } else {
    tmpvar_48 = 0.0;
  };
  specularTerm_22 = (tmpvar_45 * tmpvar_48);
  mediump float x_49;
  x_49 = (1.0 - tmpvar_32);
  mediump vec4 tmpvar_50;
  tmpvar_50.w = 1.0;
  tmpvar_50.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_38)) + ((specularTerm_22 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_49 * x_49) * ((x_49 * x_49) * x_49)))
  )));
  gl_FragData[0] = tmpvar_50;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
vec3 u_xlat4;
lowp vec3 u_xlat10_4;
mediump vec3 u_xlat16_5;
lowp vec3 u_xlat10_5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat9;
mediump float u_xlat16_9;
bool u_xlatb9;
mediump float u_xlat16_10;
mediump float u_xlat16_14;
mediump vec3 u_xlat16_15;
float u_xlat16;
bool u_xlatb16;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat18;
mediump float u_xlat16_22;
mediump float u_xlat16_23;
float u_xlat24;
float u_xlat25;
float u_xlat26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat3.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat17 = inversesqrt(u_xlat24);
    u_xlat24 = u_xlat24 * _LightPos.w;
    u_xlat24 = texture(_LightTextureB0, vec2(u_xlat24)).x;
    u_xlat4.xyz = u_xlat3.xyz * vec3(u_xlat17) + (-u_xlat2.xyz);
    u_xlat3.xyz = vec3(u_xlat17) * u_xlat3.xyz;
    u_xlat17 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat17 = max(u_xlat17, 0.00100000005);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat4.xyz = vec3(u_xlat17) * u_xlat4.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_17 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_17 = inversesqrt(u_xlat16_17);
    u_xlat16_5.xyz = vec3(u_xlat16_17) * u_xlat16_5.xyz;
    u_xlat17 = dot(u_xlat16_5.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat25 = dot(u_xlat3.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat25 = min(max(u_xlat25, 0.0), 1.0);
#else
    u_xlat25 = clamp(u_xlat25, 0.0, 1.0);
#endif
    u_xlat26 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat26 = min(max(u_xlat26, 0.0), 1.0);
#else
    u_xlat26 = clamp(u_xlat26, 0.0, 1.0);
#endif
    u_xlat2.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_4.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_1 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_9 = u_xlat16_1 * u_xlat16_1;
    u_xlat16_9 = max(u_xlat16_9, 0.00200000009);
    u_xlat16_10 = u_xlat16_9 * u_xlat16_9;
    u_xlat18 = u_xlat17 * u_xlat16_10 + (-u_xlat17);
    u_xlat17 = u_xlat18 * u_xlat17 + 1.0;
    u_xlat17 = u_xlat17 * u_xlat17 + 1.00000001e-07;
    u_xlat16_10 = u_xlat16_10 * 0.318309873;
    u_xlat17 = u_xlat16_10 / u_xlat17;
    u_xlat16_6.x = (-u_xlat16_9) + 1.0;
    u_xlat16_14 = abs(u_xlat2.x) * u_xlat16_6.x + u_xlat16_9;
    u_xlat16_6.x = u_xlat26 * u_xlat16_6.x + u_xlat16_9;
    u_xlat16_6.x = abs(u_xlat2.x) * u_xlat16_6.x;
    u_xlat16_22 = -abs(u_xlat2.x) + 1.0;
    u_xlat16_6.x = u_xlat26 * u_xlat16_14 + u_xlat16_6.x;
    u_xlat16_9 = u_xlat16_6.x + 9.99999975e-06;
    u_xlat16_9 = 0.5 / u_xlat16_9;
    u_xlat9 = u_xlat17 * u_xlat16_9;
    u_xlat9 = u_xlat9 * 3.14159274;
    u_xlat9 = max(u_xlat9, 9.99999975e-05);
    u_xlat9 = sqrt(u_xlat9);
    u_xlat16_6.x = u_xlat26 * u_xlat9;
    u_xlat16_14 = dot(u_xlat10_3.xyz, u_xlat10_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb9 = !!(u_xlat16_14!=0.0);
#else
    u_xlatb9 = u_xlat16_14!=0.0;
#endif
    u_xlat9 = u_xlatb9 ? 1.0 : float(0.0);
    u_xlat16_6.x = u_xlat9 * u_xlat16_6.x;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb16 = !!(u_xlat0.z<0.0);
#else
    u_xlatb16 = u_xlat0.z<0.0;
#endif
    u_xlat16 = u_xlatb16 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat16 * u_xlat0.x;
    u_xlat0.x = u_xlat24 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_6.xyw = u_xlat0.xyz * u_xlat16_6.xxx;
    u_xlat16_7.x = (-u_xlat25) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_3.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_3.xyz;
    u_xlat16_6.xyw = u_xlat16_6.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat25 + u_xlat25;
    u_xlat16_7.x = u_xlat25 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_1 + -0.5;
    u_xlat16_22 = u_xlat16_7.x * u_xlat16_22 + 1.0;
    u_xlat16_15.x = (-u_xlat26) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_22 = u_xlat26 * u_xlat16_22;
    u_xlat16_7.xyz = u_xlat0.xyz * vec3(u_xlat16_22);
    SV_Target0.xyz = u_xlat10_4.xyz * u_xlat16_7.xyz + u_xlat16_6.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).x;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13.w = -8.0;
  tmpvar_13.xyz = (unity_WorldToLight * tmpvar_12).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_13.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump float tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_17 = gbuffer1_2.w;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_18 = tmpvar_19;
  highp vec3 viewDir_20;
  viewDir_20 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_21;
  mediump float nv_22;
  highp float tmpvar_23;
  highp float smoothness_24;
  smoothness_24 = tmpvar_17;
  tmpvar_23 = (1.0 - smoothness_24);
  highp vec3 tmpvar_25;
  highp vec3 inVec_26;
  inVec_26 = (lightDir_6 + viewDir_20);
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  highp float tmpvar_27;
  tmpvar_27 = abs(dot (tmpvar_18, viewDir_20));
  nv_22 = tmpvar_27;
  mediump float tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_18, lightDir_6), 0.0, 1.0);
  tmpvar_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp (dot (tmpvar_18, tmpvar_25), 0.0, 1.0);
  mediump float tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp (dot (lightDir_6, tmpvar_25), 0.0, 1.0);
  tmpvar_31 = tmpvar_32;
  mediump float perceptualRoughness_33;
  perceptualRoughness_33 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = (0.5 + ((2.0 * tmpvar_31) * (tmpvar_31 * perceptualRoughness_33)));
  mediump float x_35;
  x_35 = (1.0 - tmpvar_28);
  mediump float x_36;
  x_36 = (1.0 - nv_22);
  mediump float tmpvar_37;
  tmpvar_37 = (((1.0 + 
    ((tmpvar_34 - 1.0) * ((x_35 * x_35) * ((x_35 * x_35) * x_35)))
  ) * (1.0 + 
    ((tmpvar_34 - 1.0) * ((x_36 * x_36) * ((x_36 * x_36) * x_36)))
  )) * tmpvar_28);
  highp float tmpvar_38;
  tmpvar_38 = max ((tmpvar_23 * tmpvar_23), 0.002);
  mediump float tmpvar_39;
  mediump float roughness_40;
  roughness_40 = tmpvar_38;
  tmpvar_39 = (0.5 / ((
    (tmpvar_28 * ((nv_22 * (1.0 - roughness_40)) + roughness_40))
   + 
    (nv_22 * ((tmpvar_28 * (1.0 - roughness_40)) + roughness_40))
  ) + 1e-5));
  highp float tmpvar_41;
  tmpvar_41 = (tmpvar_38 * tmpvar_38);
  highp float tmpvar_42;
  tmpvar_42 = (((
    (tmpvar_30 * tmpvar_41)
   - tmpvar_30) * tmpvar_30) + 1.0);
  highp float tmpvar_43;
  tmpvar_43 = ((tmpvar_39 * (
    (0.3183099 * tmpvar_41)
   / 
    ((tmpvar_42 * tmpvar_42) + 1e-7)
  )) * 3.141593);
  specularTerm_21 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = max (0.0, (sqrt(
    max (0.0001, specularTerm_21)
  ) * tmpvar_28));
  specularTerm_21 = tmpvar_44;
  bvec3 tmpvar_45;
  tmpvar_45 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_46;
  tmpvar_46 = any(tmpvar_45);
  highp float tmpvar_47;
  if (tmpvar_46) {
    tmpvar_47 = 1.0;
  } else {
    tmpvar_47 = 0.0;
  };
  specularTerm_21 = (tmpvar_44 * tmpvar_47);
  mediump float x_48;
  x_48 = (1.0 - tmpvar_31);
  mediump vec4 tmpvar_49;
  tmpvar_49.w = 1.0;
  tmpvar_49.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_37)) + ((specularTerm_21 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_48 * x_48) * ((x_48 * x_48) * x_48)))
  )));
  gl_FragData[0] = tmpvar_49;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
vec3 u_xlat4;
lowp vec3 u_xlat10_4;
mediump vec3 u_xlat16_5;
lowp vec3 u_xlat10_5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat9;
mediump float u_xlat16_9;
bool u_xlatb9;
mediump float u_xlat16_10;
mediump float u_xlat16_14;
mediump vec3 u_xlat16_15;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat18;
mediump float u_xlat16_22;
mediump float u_xlat16_23;
float u_xlat24;
float u_xlat25;
float u_xlat26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat17 = inversesqrt(u_xlat24);
    u_xlat24 = u_xlat24 * _LightPos.w;
    u_xlat24 = texture(_LightTextureB0, vec2(u_xlat24)).x;
    u_xlat4.xyz = (-u_xlat3.xyz) * vec3(u_xlat17) + (-u_xlat2.xyz);
    u_xlat3.xyz = vec3(u_xlat17) * u_xlat3.xyz;
    u_xlat17 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat17 = max(u_xlat17, 0.00100000005);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat4.xyz = vec3(u_xlat17) * u_xlat4.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_17 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_17 = inversesqrt(u_xlat16_17);
    u_xlat16_5.xyz = vec3(u_xlat16_17) * u_xlat16_5.xyz;
    u_xlat17 = dot(u_xlat16_5.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat25 = dot((-u_xlat3.xyz), u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat25 = min(max(u_xlat25, 0.0), 1.0);
#else
    u_xlat25 = clamp(u_xlat25, 0.0, 1.0);
#endif
    u_xlat26 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat26 = min(max(u_xlat26, 0.0), 1.0);
#else
    u_xlat26 = clamp(u_xlat26, 0.0, 1.0);
#endif
    u_xlat2.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_4.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_1 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_9 = u_xlat16_1 * u_xlat16_1;
    u_xlat16_9 = max(u_xlat16_9, 0.00200000009);
    u_xlat16_10 = u_xlat16_9 * u_xlat16_9;
    u_xlat18 = u_xlat17 * u_xlat16_10 + (-u_xlat17);
    u_xlat17 = u_xlat18 * u_xlat17 + 1.0;
    u_xlat17 = u_xlat17 * u_xlat17 + 1.00000001e-07;
    u_xlat16_10 = u_xlat16_10 * 0.318309873;
    u_xlat17 = u_xlat16_10 / u_xlat17;
    u_xlat16_6.x = (-u_xlat16_9) + 1.0;
    u_xlat16_14 = abs(u_xlat2.x) * u_xlat16_6.x + u_xlat16_9;
    u_xlat16_6.x = u_xlat26 * u_xlat16_6.x + u_xlat16_9;
    u_xlat16_6.x = abs(u_xlat2.x) * u_xlat16_6.x;
    u_xlat16_22 = -abs(u_xlat2.x) + 1.0;
    u_xlat16_6.x = u_xlat26 * u_xlat16_14 + u_xlat16_6.x;
    u_xlat16_9 = u_xlat16_6.x + 9.99999975e-06;
    u_xlat16_9 = 0.5 / u_xlat16_9;
    u_xlat9 = u_xlat17 * u_xlat16_9;
    u_xlat9 = u_xlat9 * 3.14159274;
    u_xlat9 = max(u_xlat9, 9.99999975e-05);
    u_xlat9 = sqrt(u_xlat9);
    u_xlat16_6.x = u_xlat26 * u_xlat9;
    u_xlat16_14 = dot(u_xlat10_3.xyz, u_xlat10_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb9 = !!(u_xlat16_14!=0.0);
#else
    u_xlatb9 = u_xlat16_14!=0.0;
#endif
    u_xlat9 = u_xlatb9 ? 1.0 : float(0.0);
    u_xlat16_6.x = u_xlat9 * u_xlat16_6.x;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat24;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_6.xyw = u_xlat0.xyz * u_xlat16_6.xxx;
    u_xlat16_7.x = (-u_xlat25) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_3.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_3.xyz;
    u_xlat16_6.xyw = u_xlat16_6.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat25 + u_xlat25;
    u_xlat16_7.x = u_xlat25 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_1 + -0.5;
    u_xlat16_22 = u_xlat16_7.x * u_xlat16_22 + 1.0;
    u_xlat16_15.x = (-u_xlat26) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_22 = u_xlat26 * u_xlat16_22;
    u_xlat16_7.xyz = u_xlat0.xyz * vec3(u_xlat16_22);
    SV_Target0.xyz = u_xlat10_4.xyz * u_xlat16_7.xyz + u_xlat16_6.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(0.0, -8.0);
  tmpvar_12.xy = (unity_WorldToLight * tmpvar_11).xy;
  atten_5 = texture2D (_LightTexture0, tmpvar_12.xy, -8.0).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_15;
  mediump float tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_16 = gbuffer1_2.w;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_17 = tmpvar_18;
  highp vec3 viewDir_19;
  viewDir_19 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_20;
  mediump float nv_21;
  highp float tmpvar_22;
  highp float smoothness_23;
  smoothness_23 = tmpvar_16;
  tmpvar_22 = (1.0 - smoothness_23);
  highp vec3 tmpvar_24;
  highp vec3 inVec_25;
  inVec_25 = (lightDir_6 + viewDir_19);
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  highp float tmpvar_26;
  tmpvar_26 = abs(dot (tmpvar_17, viewDir_19));
  nv_21 = tmpvar_26;
  mediump float tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_17, lightDir_6), 0.0, 1.0);
  tmpvar_27 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_17, tmpvar_24), 0.0, 1.0);
  mediump float tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (dot (lightDir_6, tmpvar_24), 0.0, 1.0);
  tmpvar_30 = tmpvar_31;
  mediump float perceptualRoughness_32;
  perceptualRoughness_32 = tmpvar_22;
  mediump float tmpvar_33;
  tmpvar_33 = (0.5 + ((2.0 * tmpvar_30) * (tmpvar_30 * perceptualRoughness_32)));
  mediump float x_34;
  x_34 = (1.0 - tmpvar_27);
  mediump float x_35;
  x_35 = (1.0 - nv_21);
  mediump float tmpvar_36;
  tmpvar_36 = (((1.0 + 
    ((tmpvar_33 - 1.0) * ((x_34 * x_34) * ((x_34 * x_34) * x_34)))
  ) * (1.0 + 
    ((tmpvar_33 - 1.0) * ((x_35 * x_35) * ((x_35 * x_35) * x_35)))
  )) * tmpvar_27);
  highp float tmpvar_37;
  tmpvar_37 = max ((tmpvar_22 * tmpvar_22), 0.002);
  mediump float tmpvar_38;
  mediump float roughness_39;
  roughness_39 = tmpvar_37;
  tmpvar_38 = (0.5 / ((
    (tmpvar_27 * ((nv_21 * (1.0 - roughness_39)) + roughness_39))
   + 
    (nv_21 * ((tmpvar_27 * (1.0 - roughness_39)) + roughness_39))
  ) + 1e-5));
  highp float tmpvar_40;
  tmpvar_40 = (tmpvar_37 * tmpvar_37);
  highp float tmpvar_41;
  tmpvar_41 = (((
    (tmpvar_29 * tmpvar_40)
   - tmpvar_29) * tmpvar_29) + 1.0);
  highp float tmpvar_42;
  tmpvar_42 = ((tmpvar_38 * (
    (0.3183099 * tmpvar_40)
   / 
    ((tmpvar_41 * tmpvar_41) + 1e-7)
  )) * 3.141593);
  specularTerm_20 = tmpvar_42;
  mediump float tmpvar_43;
  tmpvar_43 = max (0.0, (sqrt(
    max (0.0001, specularTerm_20)
  ) * tmpvar_27));
  specularTerm_20 = tmpvar_43;
  bvec3 tmpvar_44;
  tmpvar_44 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_45;
  tmpvar_45 = any(tmpvar_44);
  highp float tmpvar_46;
  if (tmpvar_45) {
    tmpvar_46 = 1.0;
  } else {
    tmpvar_46 = 0.0;
  };
  specularTerm_20 = (tmpvar_43 * tmpvar_46);
  mediump float x_47;
  x_47 = (1.0 - tmpvar_30);
  mediump vec4 tmpvar_48;
  tmpvar_48.w = 1.0;
  tmpvar_48.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_36)) + ((specularTerm_20 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_47 * x_47) * ((x_47 * x_47) * x_47)))
  )));
  gl_FragData[0] = tmpvar_48;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
mediump float u_xlat16_2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_4;
float u_xlat5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
float u_xlat10;
mediump float u_xlat16_14;
mediump vec3 u_xlat16_15;
float u_xlat17;
mediump float u_xlat16_22;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
bool u_xlatb24;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
mediump float u_xlat16_28;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat0.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-_LightDir.xyz);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_4.xyz = vec3(u_xlat16_24) * u_xlat16_4.xyz;
    u_xlat24 = dot(u_xlat16_4.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-_LightDir.xyz), u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_26 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_27 = max(u_xlat16_27, 0.00200000009);
    u_xlat16_28 = u_xlat16_27 * u_xlat16_27;
    u_xlat5 = u_xlat24 * u_xlat16_28 + (-u_xlat24);
    u_xlat24 = u_xlat5 * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_28 = u_xlat16_28 * 0.318309873;
    u_xlat24 = u_xlat16_28 / u_xlat24;
    u_xlat2.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
    u_xlat10 = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat10 = min(max(u_xlat10, 0.0), 1.0);
#else
    u_xlat10 = clamp(u_xlat10, 0.0, 1.0);
#endif
    u_xlat16_6.x = (-u_xlat16_27) + 1.0;
    u_xlat16_14 = abs(u_xlat2.x) * u_xlat16_6.x + u_xlat16_27;
    u_xlat16_6.x = u_xlat10 * u_xlat16_6.x + u_xlat16_27;
    u_xlat16_6.x = abs(u_xlat2.x) * u_xlat16_6.x;
    u_xlat16_22 = -abs(u_xlat2.x) + 1.0;
    u_xlat16_6.x = u_xlat10 * u_xlat16_14 + u_xlat16_6.x;
    u_xlat16_2 = u_xlat16_6.x + 9.99999975e-06;
    u_xlat16_2 = 0.5 / u_xlat16_2;
    u_xlat24 = u_xlat24 * u_xlat16_2;
    u_xlat24 = u_xlat24 * 3.14159274;
    u_xlat24 = max(u_xlat24, 9.99999975e-05);
    u_xlat24 = sqrt(u_xlat24);
    u_xlat16_6.x = u_xlat10 * u_xlat24;
    u_xlat16_14 = dot(u_xlat10_3.xyz, u_xlat10_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb24 = !!(u_xlat16_14!=0.0);
#else
    u_xlatb24 = u_xlat16_14!=0.0;
#endif
    u_xlat24 = u_xlatb24 ? 1.0 : float(0.0);
    u_xlat16_6.x = u_xlat24 * u_xlat16_6.x;
    u_xlat8.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat8.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_6.xyw = u_xlat0.xyz * u_xlat16_6.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_3.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_3.xyz;
    u_xlat16_6.xyw = u_xlat16_6.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_26 + -0.5;
    u_xlat16_15.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_15.x;
    u_xlat16_22 = u_xlat16_7.x * u_xlat16_22 + 1.0;
    u_xlat16_15.x = (-u_xlat10) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_7.x;
    u_xlat16_22 = u_xlat10 * u_xlat16_22;
    u_xlat16_7.xyz = u_xlat0.xyz * vec3(u_xlat16_22);
    SV_Target0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_6.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).x);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_ShadowMapTexture, tmpvar_20);
  mediump float tmpvar_23;
  if ((tmpvar_22.x < (tmpvar_20.z / tmpvar_20.w))) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  tmpvar_21 = tmpvar_23;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_24;
  tmpvar_24 = mix (shadowAttenuation_18, 1.0, tmpvar_16);
  atten_5 = (atten_5 * tmpvar_24);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump float tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_28 = gbuffer1_2.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_29 = tmpvar_30;
  highp vec3 viewDir_31;
  viewDir_31 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_32;
  mediump float nv_33;
  highp float tmpvar_34;
  highp float smoothness_35;
  smoothness_35 = tmpvar_28;
  tmpvar_34 = (1.0 - smoothness_35);
  highp vec3 tmpvar_36;
  highp vec3 inVec_37;
  inVec_37 = (lightDir_6 + viewDir_31);
  tmpvar_36 = (inVec_37 * inversesqrt(max (0.001, 
    dot (inVec_37, inVec_37)
  )));
  highp float tmpvar_38;
  tmpvar_38 = abs(dot (tmpvar_29, viewDir_31));
  nv_33 = tmpvar_38;
  mediump float tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_29, lightDir_6), 0.0, 1.0);
  tmpvar_39 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_29, tmpvar_36), 0.0, 1.0);
  mediump float tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = clamp (dot (lightDir_6, tmpvar_36), 0.0, 1.0);
  tmpvar_42 = tmpvar_43;
  mediump float perceptualRoughness_44;
  perceptualRoughness_44 = tmpvar_34;
  mediump float tmpvar_45;
  tmpvar_45 = (0.5 + ((2.0 * tmpvar_42) * (tmpvar_42 * perceptualRoughness_44)));
  mediump float x_46;
  x_46 = (1.0 - tmpvar_39);
  mediump float x_47;
  x_47 = (1.0 - nv_33);
  mediump float tmpvar_48;
  tmpvar_48 = (((1.0 + 
    ((tmpvar_45 - 1.0) * ((x_46 * x_46) * ((x_46 * x_46) * x_46)))
  ) * (1.0 + 
    ((tmpvar_45 - 1.0) * ((x_47 * x_47) * ((x_47 * x_47) * x_47)))
  )) * tmpvar_39);
  highp float tmpvar_49;
  tmpvar_49 = max ((tmpvar_34 * tmpvar_34), 0.002);
  mediump float tmpvar_50;
  mediump float roughness_51;
  roughness_51 = tmpvar_49;
  tmpvar_50 = (0.5 / ((
    (tmpvar_39 * ((nv_33 * (1.0 - roughness_51)) + roughness_51))
   + 
    (nv_33 * ((tmpvar_39 * (1.0 - roughness_51)) + roughness_51))
  ) + 1e-5));
  highp float tmpvar_52;
  tmpvar_52 = (tmpvar_49 * tmpvar_49);
  highp float tmpvar_53;
  tmpvar_53 = (((
    (tmpvar_41 * tmpvar_52)
   - tmpvar_41) * tmpvar_41) + 1.0);
  highp float tmpvar_54;
  tmpvar_54 = ((tmpvar_50 * (
    (0.3183099 * tmpvar_52)
   / 
    ((tmpvar_53 * tmpvar_53) + 1e-7)
  )) * 3.141593);
  specularTerm_32 = tmpvar_54;
  mediump float tmpvar_55;
  tmpvar_55 = max (0.0, (sqrt(
    max (0.0001, specularTerm_32)
  ) * tmpvar_39));
  specularTerm_32 = tmpvar_55;
  bvec3 tmpvar_56;
  tmpvar_56 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_57;
  tmpvar_57 = any(tmpvar_56);
  highp float tmpvar_58;
  if (tmpvar_57) {
    tmpvar_58 = 1.0;
  } else {
    tmpvar_58 = 0.0;
  };
  specularTerm_32 = (tmpvar_55 * tmpvar_58);
  mediump float x_59;
  x_59 = (1.0 - tmpvar_42);
  mediump vec4 tmpvar_60;
  tmpvar_60.w = 1.0;
  tmpvar_60.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_48)) + ((specularTerm_32 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_59 * x_59) * ((x_59 * x_59) * x_59)))
  )));
  gl_FragData[0] = tmpvar_60;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
mediump vec4 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
lowp float u_xlat10_8;
bool u_xlatb8;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_15;
float u_xlat16;
mediump float u_xlat16_16;
bool u_xlatb16;
float u_xlat17;
mediump float u_xlat16_20;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat8.xyz = u_xlat3.xyz / u_xlat3.www;
    vec3 txVec0 = vec3(u_xlat8.xy,u_xlat8.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_16 = (-_LightShadowData.x) + 1.0;
    u_xlat16_8 = u_xlat10_8 * u_xlat16_16 + _LightShadowData.x;
    u_xlat16_4.x = (-u_xlat16_8) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_4.x + u_xlat16_8;
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb16 = !!(u_xlat0.z<0.0);
#else
    u_xlatb16 = u_xlat0.z<0.0;
#endif
    u_xlat16 = u_xlatb16 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat16 * u_xlat0.x;
    u_xlat8.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat25 = texture(_LightTextureB0, vec2(u_xlat25)).x;
    u_xlat0.x = u_xlat0.x * u_xlat25;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat5.xyz = u_xlat8.xyz * vec3(u_xlat17) + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat8.xyz * vec3(u_xlat17);
    u_xlat24 = dot(u_xlat5.xyz, u_xlat5.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat5.xyz = vec3(u_xlat24) * u_xlat5.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_6.xyz = vec3(u_xlat16_24) * u_xlat16_6.xyz;
    u_xlat24 = dot(u_xlat16_6.xyz, u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot(u_xlat0.xyz, u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_6.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.x = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat5.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat5.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_4.x = (-u_xlat16_26) + 1.0;
    u_xlat16_12 = abs(u_xlat8.x) * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = abs(u_xlat8.x) * u_xlat16_4.x;
    u_xlat16_20 = -abs(u_xlat8.x) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_12 + u_xlat16_4.x;
    u_xlat16_8 = u_xlat16_4.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8.x = u_xlat24 * u_xlat16_8;
    u_xlat8.x = u_xlat8.x * 3.14159274;
    u_xlat8.x = max(u_xlat8.x, 9.99999975e-05);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat16_4.x = u_xlat0.x * u_xlat8.x;
    u_xlat16_12 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb8 = u_xlat16_12!=0.0;
#endif
    u_xlat8.x = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_4.x = u_xlat8.x * u_xlat16_4.x;
    u_xlat16_4.xyw = u_xlat3.xyz * u_xlat16_4.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_4.xyw = u_xlat16_4.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_20 * u_xlat16_20;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_20 = u_xlat16_7.x * u_xlat16_20 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_20 = u_xlat0.x * u_xlat16_20;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_20);
    SV_Target0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_4.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).x);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 shadowVals_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_20.xyz / tmpvar_20.w);
  shadowVals_22.x = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_22.y = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_22.z = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_22.w = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_22, tmpvar_23.zzzz);
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_21 = tmpvar_31;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_32;
  tmpvar_32 = mix (shadowAttenuation_18, 1.0, tmpvar_16);
  atten_5 = (atten_5 * tmpvar_32);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_35;
  mediump float tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_36 = gbuffer1_2.w;
  mediump vec3 tmpvar_38;
  tmpvar_38 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_37 = tmpvar_38;
  highp vec3 viewDir_39;
  viewDir_39 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_40;
  mediump float nv_41;
  highp float tmpvar_42;
  highp float smoothness_43;
  smoothness_43 = tmpvar_36;
  tmpvar_42 = (1.0 - smoothness_43);
  highp vec3 tmpvar_44;
  highp vec3 inVec_45;
  inVec_45 = (lightDir_6 + viewDir_39);
  tmpvar_44 = (inVec_45 * inversesqrt(max (0.001, 
    dot (inVec_45, inVec_45)
  )));
  highp float tmpvar_46;
  tmpvar_46 = abs(dot (tmpvar_37, viewDir_39));
  nv_41 = tmpvar_46;
  mediump float tmpvar_47;
  highp float tmpvar_48;
  tmpvar_48 = clamp (dot (tmpvar_37, lightDir_6), 0.0, 1.0);
  tmpvar_47 = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = clamp (dot (tmpvar_37, tmpvar_44), 0.0, 1.0);
  mediump float tmpvar_50;
  highp float tmpvar_51;
  tmpvar_51 = clamp (dot (lightDir_6, tmpvar_44), 0.0, 1.0);
  tmpvar_50 = tmpvar_51;
  mediump float perceptualRoughness_52;
  perceptualRoughness_52 = tmpvar_42;
  mediump float tmpvar_53;
  tmpvar_53 = (0.5 + ((2.0 * tmpvar_50) * (tmpvar_50 * perceptualRoughness_52)));
  mediump float x_54;
  x_54 = (1.0 - tmpvar_47);
  mediump float x_55;
  x_55 = (1.0 - nv_41);
  mediump float tmpvar_56;
  tmpvar_56 = (((1.0 + 
    ((tmpvar_53 - 1.0) * ((x_54 * x_54) * ((x_54 * x_54) * x_54)))
  ) * (1.0 + 
    ((tmpvar_53 - 1.0) * ((x_55 * x_55) * ((x_55 * x_55) * x_55)))
  )) * tmpvar_47);
  highp float tmpvar_57;
  tmpvar_57 = max ((tmpvar_42 * tmpvar_42), 0.002);
  mediump float tmpvar_58;
  mediump float roughness_59;
  roughness_59 = tmpvar_57;
  tmpvar_58 = (0.5 / ((
    (tmpvar_47 * ((nv_41 * (1.0 - roughness_59)) + roughness_59))
   + 
    (nv_41 * ((tmpvar_47 * (1.0 - roughness_59)) + roughness_59))
  ) + 1e-5));
  highp float tmpvar_60;
  tmpvar_60 = (tmpvar_57 * tmpvar_57);
  highp float tmpvar_61;
  tmpvar_61 = (((
    (tmpvar_49 * tmpvar_60)
   - tmpvar_49) * tmpvar_49) + 1.0);
  highp float tmpvar_62;
  tmpvar_62 = ((tmpvar_58 * (
    (0.3183099 * tmpvar_60)
   / 
    ((tmpvar_61 * tmpvar_61) + 1e-7)
  )) * 3.141593);
  specularTerm_40 = tmpvar_62;
  mediump float tmpvar_63;
  tmpvar_63 = max (0.0, (sqrt(
    max (0.0001, specularTerm_40)
  ) * tmpvar_47));
  specularTerm_40 = tmpvar_63;
  bvec3 tmpvar_64;
  tmpvar_64 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_65;
  tmpvar_65 = any(tmpvar_64);
  highp float tmpvar_66;
  if (tmpvar_65) {
    tmpvar_66 = 1.0;
  } else {
    tmpvar_66 = 0.0;
  };
  specularTerm_40 = (tmpvar_63 * tmpvar_66);
  mediump float x_67;
  x_67 = (1.0 - tmpvar_50);
  mediump vec4 tmpvar_68;
  tmpvar_68.w = 1.0;
  tmpvar_68.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_56)) + ((specularTerm_40 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_67 * x_67) * ((x_67 * x_67) * x_67)))
  )));
  gl_FragData[0] = tmpvar_68;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
lowp float u_xlat10_0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
mediump vec3 u_xlat16_5;
lowp vec3 u_xlat10_5;
vec4 u_xlat6;
vec4 u_xlat7;
mediump vec4 u_xlat16_8;
mediump vec3 u_xlat16_9;
vec3 u_xlat10;
mediump float u_xlat16_10;
lowp float u_xlat10_10;
bool u_xlatb10;
mediump float u_xlat16_18;
mediump vec3 u_xlat16_19;
float u_xlat20;
mediump float u_xlat16_20;
bool u_xlatb20;
vec2 u_xlat21;
lowp float u_xlat10_21;
mediump float u_xlat16_28;
mediump float u_xlat16_29;
float u_xlat30;
mediump float u_xlat16_30;
float u_xlat31;
mediump float u_xlat16_32;
mediump float u_xlat16_33;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat30 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat30 = _ZBufferParams.x * u_xlat30 + _ZBufferParams.y;
    u_xlat30 = float(1.0) / u_xlat30;
    u_xlat2.xyz = vec3(u_xlat30) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    u_xlat0.xy = u_xlat3.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat0.xy = floor(u_xlat0.xy);
    u_xlat21.xy = u_xlat3.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat0.xy);
    u_xlat3.xy = (-u_xlat21.xy) + vec2(1.0, 1.0);
    u_xlat4.xy = min(u_xlat21.xy, vec2(0.0, 0.0));
    u_xlat4.xy = (-u_xlat4.xy) * u_xlat4.xy + u_xlat3.xy;
    u_xlat5.y = u_xlat4.x;
    u_xlat3.xy = max(u_xlat21.xy, vec2(0.0, 0.0));
    u_xlat6 = u_xlat21.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat4.xz = (-u_xlat3.xy) * u_xlat3.xy + u_xlat6.yw;
    u_xlat3.xy = u_xlat6.xz * u_xlat6.xz;
    u_xlat5.z = u_xlat4.x;
    u_xlat21.xy = u_xlat3.xy * vec2(0.5, 0.5) + (-u_xlat21.xy);
    u_xlat5.x = u_xlat21.x;
    u_xlat4.x = u_xlat21.y;
    u_xlat5.w = u_xlat3.x;
    u_xlat4.w = u_xlat3.y;
    u_xlat4 = u_xlat4 * vec4(0.444440007, 0.444440007, 0.444440007, 0.222220004);
    u_xlat5 = u_xlat5 * vec4(0.444440007, 0.444440007, 0.444440007, 0.222220004);
    u_xlat6 = vec4(u_xlat5.y + u_xlat5.x, u_xlat5.w + u_xlat5.z, u_xlat5.y + u_xlat5.x, u_xlat5.w + u_xlat5.z);
    u_xlat21.xy = vec2(u_xlat5.y / u_xlat6.z, u_xlat5.w / u_xlat6.w);
    u_xlat21.xy = u_xlat21.xy + vec2(-1.5, 0.5);
    u_xlat5.xy = u_xlat21.xy * _ShadowMapTexture_TexelSize.xx;
    u_xlat7 = vec4(u_xlat4.y + u_xlat4.x, u_xlat4.y + u_xlat4.x, u_xlat4.w + u_xlat4.z, u_xlat4.w + u_xlat4.z);
    u_xlat21.xy = vec2(u_xlat4.y / u_xlat7.y, u_xlat4.w / u_xlat7.w);
    u_xlat4 = u_xlat6 * u_xlat7;
    u_xlat21.xy = u_xlat21.xy + vec2(-1.5, 0.5);
    u_xlat5.zw = u_xlat21.xy * _ShadowMapTexture_TexelSize.yy;
    u_xlat6 = u_xlat0.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xzyz;
    u_xlat5 = u_xlat0.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwyw;
    vec3 txVec0 = vec3(u_xlat6.xy,u_xlat3.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat6.zw,u_xlat3.z);
    u_xlat10_10 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat10.x = u_xlat10_10 * u_xlat4.y;
    u_xlat0.x = u_xlat4.x * u_xlat10_0 + u_xlat10.x;
    vec3 txVec2 = vec3(u_xlat5.xy,u_xlat3.z);
    u_xlat10_10 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat5.zw,u_xlat3.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat0.x = u_xlat4.z * u_xlat10_10 + u_xlat0.x;
    u_xlat0.x = u_xlat4.w * u_xlat10_21 + u_xlat0.x;
    u_xlat16_10 = (-_LightShadowData.x) + 1.0;
    u_xlat0.x = u_xlat0.x * u_xlat16_10 + _LightShadowData.x;
    u_xlat16_8.x = (-u_xlat0.x) + 1.0;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat10.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat10.x = sqrt(u_xlat10.x);
    u_xlat10.x = (-u_xlat0.z) * u_xlat30 + u_xlat10.x;
    u_xlat10.x = unity_ShadowFadeCenterAndType.w * u_xlat10.x + u_xlat2.z;
    u_xlat10.x = u_xlat10.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat10.x = min(max(u_xlat10.x, 0.0), 1.0);
#else
    u_xlat10.x = clamp(u_xlat10.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat10.x * u_xlat16_8.x + u_xlat0.x;
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb20 = !!(u_xlat0.z<0.0);
#else
    u_xlatb20 = u_xlat0.z<0.0;
#endif
    u_xlat20 = u_xlatb20 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat20 * u_xlat0.x;
    u_xlat10.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat21.x = dot(u_xlat10.xyz, u_xlat10.xyz);
    u_xlat31 = u_xlat21.x * _LightPos.w;
    u_xlat21.x = inversesqrt(u_xlat21.x);
    u_xlat31 = texture(_LightTextureB0, vec2(u_xlat31)).x;
    u_xlat0.x = u_xlat0.x * u_xlat31;
    u_xlat0.x = u_xlat16_8.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat4.xyz = u_xlat10.xyz * u_xlat21.xxx + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat10.xyz * u_xlat21.xxx;
    u_xlat30 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat30 = max(u_xlat30, 0.00100000005);
    u_xlat30 = inversesqrt(u_xlat30);
    u_xlat4.xyz = vec3(u_xlat30) * u_xlat4.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_30 = inversesqrt(u_xlat16_30);
    u_xlat16_5.xyz = vec3(u_xlat16_30) * u_xlat16_5.xyz;
    u_xlat30 = dot(u_xlat16_5.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat30 = min(max(u_xlat30, 0.0), 1.0);
#else
    u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
#endif
    u_xlat21.x = dot(u_xlat0.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat21.x = min(max(u_xlat21.x, 0.0), 1.0);
#else
    u_xlat21.x = clamp(u_xlat21.x, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_5.xyz, u_xlat0.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_20 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_32 = u_xlat16_20 * u_xlat16_20;
    u_xlat16_32 = max(u_xlat16_32, 0.00200000009);
    u_xlat16_33 = u_xlat16_32 * u_xlat16_32;
    u_xlat4.x = u_xlat30 * u_xlat16_33 + (-u_xlat30);
    u_xlat30 = u_xlat4.x * u_xlat30 + 1.0;
    u_xlat30 = u_xlat30 * u_xlat30 + 1.00000001e-07;
    u_xlat16_33 = u_xlat16_33 * 0.318309873;
    u_xlat30 = u_xlat16_33 / u_xlat30;
    u_xlat16_8.x = (-u_xlat16_32) + 1.0;
    u_xlat16_18 = abs(u_xlat10.x) * u_xlat16_8.x + u_xlat16_32;
    u_xlat16_8.x = u_xlat0.x * u_xlat16_8.x + u_xlat16_32;
    u_xlat16_8.x = abs(u_xlat10.x) * u_xlat16_8.x;
    u_xlat16_28 = -abs(u_xlat10.x) + 1.0;
    u_xlat16_8.x = u_xlat0.x * u_xlat16_18 + u_xlat16_8.x;
    u_xlat16_10 = u_xlat16_8.x + 9.99999975e-06;
    u_xlat16_10 = 0.5 / u_xlat16_10;
    u_xlat10.x = u_xlat30 * u_xlat16_10;
    u_xlat10.x = u_xlat10.x * 3.14159274;
    u_xlat10.x = max(u_xlat10.x, 9.99999975e-05);
    u_xlat10.x = sqrt(u_xlat10.x);
    u_xlat16_8.x = u_xlat0.x * u_xlat10.x;
    u_xlat16_18 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb10 = !!(u_xlat16_18!=0.0);
#else
    u_xlatb10 = u_xlat16_18!=0.0;
#endif
    u_xlat10.x = u_xlatb10 ? 1.0 : float(0.0);
    u_xlat16_8.x = u_xlat10.x * u_xlat16_8.x;
    u_xlat16_8.xyw = u_xlat3.xyz * u_xlat16_8.xxx;
    u_xlat16_9.x = (-u_xlat21.x) + 1.0;
    u_xlat16_19.x = u_xlat16_9.x * u_xlat16_9.x;
    u_xlat16_19.x = u_xlat16_19.x * u_xlat16_19.x;
    u_xlat16_9.x = u_xlat16_9.x * u_xlat16_19.x;
    u_xlat16_19.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_9.xyz = u_xlat16_19.xyz * u_xlat16_9.xxx + u_xlat10_2.xyz;
    u_xlat16_8.xyw = u_xlat16_8.xyw * u_xlat16_9.xyz;
    u_xlat16_9.x = u_xlat16_28 * u_xlat16_28;
    u_xlat16_9.x = u_xlat16_9.x * u_xlat16_9.x;
    u_xlat16_28 = u_xlat16_28 * u_xlat16_9.x;
    u_xlat16_9.x = u_xlat21.x + u_xlat21.x;
    u_xlat16_9.x = u_xlat21.x * u_xlat16_9.x;
    u_xlat16_9.x = u_xlat16_9.x * u_xlat16_20 + -0.5;
    u_xlat16_28 = u_xlat16_9.x * u_xlat16_28 + 1.0;
    u_xlat16_19.x = (-u_xlat0.x) + 1.0;
    u_xlat16_29 = u_xlat16_19.x * u_xlat16_19.x;
    u_xlat16_29 = u_xlat16_29 * u_xlat16_29;
    u_xlat16_19.x = u_xlat16_19.x * u_xlat16_29;
    u_xlat16_9.x = u_xlat16_9.x * u_xlat16_19.x + 1.0;
    u_xlat16_28 = u_xlat16_28 * u_xlat16_9.x;
    u_xlat16_28 = u_xlat0.x * u_xlat16_28;
    u_xlat16_9.xyz = u_xlat3.xyz * vec3(u_xlat16_28);
    SV_Target0.xyz = u_xlat10_1.xyw * u_xlat16_9.xyz + u_xlat16_8.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = mix (shadowAttenuation_14, 1.0, tmpvar_12);
  atten_5 = tmpvar_16;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump float tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_20 = gbuffer1_2.w;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_21 = tmpvar_22;
  highp vec3 viewDir_23;
  viewDir_23 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_24;
  mediump float nv_25;
  highp float tmpvar_26;
  highp float smoothness_27;
  smoothness_27 = tmpvar_20;
  tmpvar_26 = (1.0 - smoothness_27);
  highp vec3 tmpvar_28;
  highp vec3 inVec_29;
  inVec_29 = (lightDir_6 + viewDir_23);
  tmpvar_28 = (inVec_29 * inversesqrt(max (0.001, 
    dot (inVec_29, inVec_29)
  )));
  highp float tmpvar_30;
  tmpvar_30 = abs(dot (tmpvar_21, viewDir_23));
  nv_25 = tmpvar_30;
  mediump float tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_21, lightDir_6), 0.0, 1.0);
  tmpvar_31 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_21, tmpvar_28), 0.0, 1.0);
  mediump float tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp (dot (lightDir_6, tmpvar_28), 0.0, 1.0);
  tmpvar_34 = tmpvar_35;
  mediump float perceptualRoughness_36;
  perceptualRoughness_36 = tmpvar_26;
  mediump float tmpvar_37;
  tmpvar_37 = (0.5 + ((2.0 * tmpvar_34) * (tmpvar_34 * perceptualRoughness_36)));
  mediump float x_38;
  x_38 = (1.0 - tmpvar_31);
  mediump float x_39;
  x_39 = (1.0 - nv_25);
  mediump float tmpvar_40;
  tmpvar_40 = (((1.0 + 
    ((tmpvar_37 - 1.0) * ((x_38 * x_38) * ((x_38 * x_38) * x_38)))
  ) * (1.0 + 
    ((tmpvar_37 - 1.0) * ((x_39 * x_39) * ((x_39 * x_39) * x_39)))
  )) * tmpvar_31);
  highp float tmpvar_41;
  tmpvar_41 = max ((tmpvar_26 * tmpvar_26), 0.002);
  mediump float tmpvar_42;
  mediump float roughness_43;
  roughness_43 = tmpvar_41;
  tmpvar_42 = (0.5 / ((
    (tmpvar_31 * ((nv_25 * (1.0 - roughness_43)) + roughness_43))
   + 
    (nv_25 * ((tmpvar_31 * (1.0 - roughness_43)) + roughness_43))
  ) + 1e-5));
  highp float tmpvar_44;
  tmpvar_44 = (tmpvar_41 * tmpvar_41);
  highp float tmpvar_45;
  tmpvar_45 = (((
    (tmpvar_33 * tmpvar_44)
   - tmpvar_33) * tmpvar_33) + 1.0);
  highp float tmpvar_46;
  tmpvar_46 = ((tmpvar_42 * (
    (0.3183099 * tmpvar_44)
   / 
    ((tmpvar_45 * tmpvar_45) + 1e-7)
  )) * 3.141593);
  specularTerm_24 = tmpvar_46;
  mediump float tmpvar_47;
  tmpvar_47 = max (0.0, (sqrt(
    max (0.0001, specularTerm_24)
  ) * tmpvar_31));
  specularTerm_24 = tmpvar_47;
  bvec3 tmpvar_48;
  tmpvar_48 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_49;
  tmpvar_49 = any(tmpvar_48);
  highp float tmpvar_50;
  if (tmpvar_49) {
    tmpvar_50 = 1.0;
  } else {
    tmpvar_50 = 0.0;
  };
  specularTerm_24 = (tmpvar_47 * tmpvar_50);
  mediump float x_51;
  x_51 = (1.0 - tmpvar_34);
  mediump vec4 tmpvar_52;
  tmpvar_52.w = 1.0;
  tmpvar_52.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_40)) + ((specularTerm_24 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_51 * x_51) * ((x_51 * x_51) * x_51)))
  )));
  gl_FragData[0] = tmpvar_52;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_3;
lowp vec3 u_xlat10_3;
mediump float u_xlat16_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
bool u_xlatb7;
float u_xlat11;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_13;
float u_xlat14;
float u_xlat15;
mediump float u_xlat16_15;
mediump float u_xlat16_19;
mediump float u_xlat16_20;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_23;
mediump float u_xlat16_24;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat2.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-_LightDir.xyz);
    u_xlat7.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = max(u_xlat15, 0.00100000005);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat2.xyz = vec3(u_xlat15) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_3.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_15 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_15 = inversesqrt(u_xlat16_15);
    u_xlat16_3.xyz = vec3(u_xlat16_15) * u_xlat16_3.xyz;
    u_xlat15 = dot(u_xlat16_3.xyz, u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat15 = min(max(u_xlat15, 0.0), 1.0);
#else
    u_xlat15 = clamp(u_xlat15, 0.0, 1.0);
#endif
    u_xlat22 = dot((-_LightDir.xyz), u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat22 = min(max(u_xlat22, 0.0), 1.0);
#else
    u_xlat22 = clamp(u_xlat22, 0.0, 1.0);
#endif
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_23 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_24 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_24 = max(u_xlat16_24, 0.00200000009);
    u_xlat16_4 = u_xlat16_24 * u_xlat16_24;
    u_xlat11 = u_xlat15 * u_xlat16_4 + (-u_xlat15);
    u_xlat15 = u_xlat11 * u_xlat15 + 1.0;
    u_xlat15 = u_xlat15 * u_xlat15 + 1.00000001e-07;
    u_xlat16_4 = u_xlat16_4 * 0.318309873;
    u_xlat15 = u_xlat16_4 / u_xlat15;
    u_xlat7.x = dot(u_xlat16_3.xyz, (-u_xlat7.xyz));
    u_xlat14 = dot(u_xlat16_3.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat16_5.x = (-u_xlat16_24) + 1.0;
    u_xlat16_12 = abs(u_xlat7.x) * u_xlat16_5.x + u_xlat16_24;
    u_xlat16_5.x = u_xlat14 * u_xlat16_5.x + u_xlat16_24;
    u_xlat16_5.x = abs(u_xlat7.x) * u_xlat16_5.x;
    u_xlat16_19 = -abs(u_xlat7.x) + 1.0;
    u_xlat16_5.x = u_xlat14 * u_xlat16_12 + u_xlat16_5.x;
    u_xlat16_7 = u_xlat16_5.x + 9.99999975e-06;
    u_xlat16_7 = 0.5 / u_xlat16_7;
    u_xlat7.x = u_xlat15 * u_xlat16_7;
    u_xlat7.x = u_xlat7.x * 3.14159274;
    u_xlat7.x = max(u_xlat7.x, 9.99999975e-05);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat16_5.x = u_xlat14 * u_xlat7.x;
    u_xlat16_12 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb7 = u_xlat16_12!=0.0;
#endif
    u_xlat7.x = u_xlatb7 ? 1.0 : float(0.0);
    u_xlat16_5.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat10_7 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_12 = (-u_xlat10_7) + 1.0;
    u_xlat16_12 = u_xlat0.x * u_xlat16_12 + u_xlat10_7;
    u_xlat0.xyw = vec3(u_xlat16_12) * _LightColor.xyz;
    u_xlat16_5.xyw = u_xlat0.xyw * u_xlat16_5.xxx;
    u_xlat16_6.x = (-u_xlat22) + 1.0;
    u_xlat16_13.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_13.x;
    u_xlat16_13.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_6.xyz = u_xlat16_13.xyz * u_xlat16_6.xxx + u_xlat10_2.xyz;
    u_xlat16_5.xyw = u_xlat16_5.xyw * u_xlat16_6.xyz;
    u_xlat16_6.x = u_xlat22 + u_xlat22;
    u_xlat16_6.x = u_xlat22 * u_xlat16_6.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_23 + -0.5;
    u_xlat16_13.x = u_xlat16_19 * u_xlat16_19;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_19 = u_xlat16_19 * u_xlat16_13.x;
    u_xlat16_19 = u_xlat16_6.x * u_xlat16_19 + 1.0;
    u_xlat16_13.x = (-u_xlat14) + 1.0;
    u_xlat16_20 = u_xlat16_13.x * u_xlat16_13.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_20;
    u_xlat16_13.x = u_xlat16_13.x * u_xlat16_20;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_13.x + 1.0;
    u_xlat16_19 = u_xlat16_19 * u_xlat16_6.x;
    u_xlat16_19 = u_xlat14 * u_xlat16_19;
    u_xlat16_6.xyz = u_xlat0.xyw * vec3(u_xlat16_19);
    SV_Target0.xyz = u_xlat10_1.xyz * u_xlat16_6.xyz + u_xlat16_5.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = mix (shadowAttenuation_14, 1.0, tmpvar_12);
  atten_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_9;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  atten_5 = (atten_5 * texture2D (_LightTexture0, tmpvar_18.xy, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  mediump float tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_22 = gbuffer1_2.w;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_23 = tmpvar_24;
  highp vec3 viewDir_25;
  viewDir_25 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_26;
  mediump float nv_27;
  highp float tmpvar_28;
  highp float smoothness_29;
  smoothness_29 = tmpvar_22;
  tmpvar_28 = (1.0 - smoothness_29);
  highp vec3 tmpvar_30;
  highp vec3 inVec_31;
  inVec_31 = (lightDir_6 + viewDir_25);
  tmpvar_30 = (inVec_31 * inversesqrt(max (0.001, 
    dot (inVec_31, inVec_31)
  )));
  highp float tmpvar_32;
  tmpvar_32 = abs(dot (tmpvar_23, viewDir_25));
  nv_27 = tmpvar_32;
  mediump float tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_23, lightDir_6), 0.0, 1.0);
  tmpvar_33 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_23, tmpvar_30), 0.0, 1.0);
  mediump float tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp (dot (lightDir_6, tmpvar_30), 0.0, 1.0);
  tmpvar_36 = tmpvar_37;
  mediump float perceptualRoughness_38;
  perceptualRoughness_38 = tmpvar_28;
  mediump float tmpvar_39;
  tmpvar_39 = (0.5 + ((2.0 * tmpvar_36) * (tmpvar_36 * perceptualRoughness_38)));
  mediump float x_40;
  x_40 = (1.0 - tmpvar_33);
  mediump float x_41;
  x_41 = (1.0 - nv_27);
  mediump float tmpvar_42;
  tmpvar_42 = (((1.0 + 
    ((tmpvar_39 - 1.0) * ((x_40 * x_40) * ((x_40 * x_40) * x_40)))
  ) * (1.0 + 
    ((tmpvar_39 - 1.0) * ((x_41 * x_41) * ((x_41 * x_41) * x_41)))
  )) * tmpvar_33);
  highp float tmpvar_43;
  tmpvar_43 = max ((tmpvar_28 * tmpvar_28), 0.002);
  mediump float tmpvar_44;
  mediump float roughness_45;
  roughness_45 = tmpvar_43;
  tmpvar_44 = (0.5 / ((
    (tmpvar_33 * ((nv_27 * (1.0 - roughness_45)) + roughness_45))
   + 
    (nv_27 * ((tmpvar_33 * (1.0 - roughness_45)) + roughness_45))
  ) + 1e-5));
  highp float tmpvar_46;
  tmpvar_46 = (tmpvar_43 * tmpvar_43);
  highp float tmpvar_47;
  tmpvar_47 = (((
    (tmpvar_35 * tmpvar_46)
   - tmpvar_35) * tmpvar_35) + 1.0);
  highp float tmpvar_48;
  tmpvar_48 = ((tmpvar_44 * (
    (0.3183099 * tmpvar_46)
   / 
    ((tmpvar_47 * tmpvar_47) + 1e-7)
  )) * 3.141593);
  specularTerm_26 = tmpvar_48;
  mediump float tmpvar_49;
  tmpvar_49 = max (0.0, (sqrt(
    max (0.0001, specularTerm_26)
  ) * tmpvar_33));
  specularTerm_26 = tmpvar_49;
  bvec3 tmpvar_50;
  tmpvar_50 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_51;
  tmpvar_51 = any(tmpvar_50);
  highp float tmpvar_52;
  if (tmpvar_51) {
    tmpvar_52 = 1.0;
  } else {
    tmpvar_52 = 0.0;
  };
  specularTerm_26 = (tmpvar_49 * tmpvar_52);
  mediump float x_53;
  x_53 = (1.0 - tmpvar_36);
  mediump vec4 tmpvar_54;
  tmpvar_54.w = 1.0;
  tmpvar_54.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_42)) + ((specularTerm_26 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_53 * x_53) * ((x_53 * x_53) * x_53)))
  )));
  gl_FragData[0] = tmpvar_54;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
mediump float u_xlat16_2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
lowp vec3 u_xlat10_5;
float u_xlat6;
mediump vec3 u_xlat16_7;
lowp float u_xlat10_8;
float u_xlat10;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_15;
float u_xlat17;
mediump float u_xlat16_20;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
bool u_xlatb24;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
mediump float u_xlat16_29;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_8 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_4.x = (-u_xlat10_8) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_4.x + u_xlat10_8;
    u_xlat0.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat0.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat16_4.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-_LightDir.xyz);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat24 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat3.xyz = vec3(u_xlat24) * u_xlat3.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_5.xyz = vec3(u_xlat16_24) * u_xlat16_5.xyz;
    u_xlat24 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-_LightDir.xyz), u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_26 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_27 = max(u_xlat16_27, 0.00200000009);
    u_xlat16_29 = u_xlat16_27 * u_xlat16_27;
    u_xlat6 = u_xlat24 * u_xlat16_29 + (-u_xlat24);
    u_xlat24 = u_xlat6 * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_29 = u_xlat16_29 * 0.318309873;
    u_xlat24 = u_xlat16_29 / u_xlat24;
    u_xlat2.x = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat10 = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat10 = min(max(u_xlat10, 0.0), 1.0);
#else
    u_xlat10 = clamp(u_xlat10, 0.0, 1.0);
#endif
    u_xlat16_4.x = (-u_xlat16_27) + 1.0;
    u_xlat16_12 = abs(u_xlat2.x) * u_xlat16_4.x + u_xlat16_27;
    u_xlat16_4.x = u_xlat10 * u_xlat16_4.x + u_xlat16_27;
    u_xlat16_4.x = abs(u_xlat2.x) * u_xlat16_4.x;
    u_xlat16_20 = -abs(u_xlat2.x) + 1.0;
    u_xlat16_4.x = u_xlat10 * u_xlat16_12 + u_xlat16_4.x;
    u_xlat16_2 = u_xlat16_4.x + 9.99999975e-06;
    u_xlat16_2 = 0.5 / u_xlat16_2;
    u_xlat24 = u_xlat24 * u_xlat16_2;
    u_xlat24 = u_xlat24 * 3.14159274;
    u_xlat24 = max(u_xlat24, 9.99999975e-05);
    u_xlat24 = sqrt(u_xlat24);
    u_xlat16_4.x = u_xlat10 * u_xlat24;
    u_xlat16_12 = dot(u_xlat10_3.xyz, u_xlat10_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb24 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb24 = u_xlat16_12!=0.0;
#endif
    u_xlat24 = u_xlatb24 ? 1.0 : float(0.0);
    u_xlat16_4.x = u_xlat24 * u_xlat16_4.x;
    u_xlat16_4.xyw = u_xlat0.xyz * u_xlat16_4.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_3.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_3.xyz;
    u_xlat16_4.xyw = u_xlat16_4.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_26 + -0.5;
    u_xlat16_15.x = u_xlat16_20 * u_xlat16_20;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_15.x;
    u_xlat16_20 = u_xlat16_7.x * u_xlat16_20 + 1.0;
    u_xlat16_15.x = (-u_xlat10) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_20 = u_xlat10 * u_xlat16_20;
    u_xlat16_7.xyz = u_xlat0.xyz * vec3(u_xlat16_20);
    SV_Target0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_4.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.x;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = mix (tmpvar_21, 1.0, tmpvar_14);
  atten_5 = (tmpvar_13.x * tmpvar_22);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_25;
  mediump float tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_26 = gbuffer1_2.w;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_27 = tmpvar_28;
  highp vec3 viewDir_29;
  viewDir_29 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_30;
  mediump float nv_31;
  highp float tmpvar_32;
  highp float smoothness_33;
  smoothness_33 = tmpvar_26;
  tmpvar_32 = (1.0 - smoothness_33);
  highp vec3 tmpvar_34;
  highp vec3 inVec_35;
  inVec_35 = (lightDir_6 + viewDir_29);
  tmpvar_34 = (inVec_35 * inversesqrt(max (0.001, 
    dot (inVec_35, inVec_35)
  )));
  highp float tmpvar_36;
  tmpvar_36 = abs(dot (tmpvar_27, viewDir_29));
  nv_31 = tmpvar_36;
  mediump float tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = clamp (dot (tmpvar_27, lightDir_6), 0.0, 1.0);
  tmpvar_37 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (tmpvar_27, tmpvar_34), 0.0, 1.0);
  mediump float tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = clamp (dot (lightDir_6, tmpvar_34), 0.0, 1.0);
  tmpvar_40 = tmpvar_41;
  mediump float perceptualRoughness_42;
  perceptualRoughness_42 = tmpvar_32;
  mediump float tmpvar_43;
  tmpvar_43 = (0.5 + ((2.0 * tmpvar_40) * (tmpvar_40 * perceptualRoughness_42)));
  mediump float x_44;
  x_44 = (1.0 - tmpvar_37);
  mediump float x_45;
  x_45 = (1.0 - nv_31);
  mediump float tmpvar_46;
  tmpvar_46 = (((1.0 + 
    ((tmpvar_43 - 1.0) * ((x_44 * x_44) * ((x_44 * x_44) * x_44)))
  ) * (1.0 + 
    ((tmpvar_43 - 1.0) * ((x_45 * x_45) * ((x_45 * x_45) * x_45)))
  )) * tmpvar_37);
  highp float tmpvar_47;
  tmpvar_47 = max ((tmpvar_32 * tmpvar_32), 0.002);
  mediump float tmpvar_48;
  mediump float roughness_49;
  roughness_49 = tmpvar_47;
  tmpvar_48 = (0.5 / ((
    (tmpvar_37 * ((nv_31 * (1.0 - roughness_49)) + roughness_49))
   + 
    (nv_31 * ((tmpvar_37 * (1.0 - roughness_49)) + roughness_49))
  ) + 1e-5));
  highp float tmpvar_50;
  tmpvar_50 = (tmpvar_47 * tmpvar_47);
  highp float tmpvar_51;
  tmpvar_51 = (((
    (tmpvar_39 * tmpvar_50)
   - tmpvar_39) * tmpvar_39) + 1.0);
  highp float tmpvar_52;
  tmpvar_52 = ((tmpvar_48 * (
    (0.3183099 * tmpvar_50)
   / 
    ((tmpvar_51 * tmpvar_51) + 1e-7)
  )) * 3.141593);
  specularTerm_30 = tmpvar_52;
  mediump float tmpvar_53;
  tmpvar_53 = max (0.0, (sqrt(
    max (0.0001, specularTerm_30)
  ) * tmpvar_37));
  specularTerm_30 = tmpvar_53;
  bvec3 tmpvar_54;
  tmpvar_54 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_55;
  tmpvar_55 = any(tmpvar_54);
  highp float tmpvar_56;
  if (tmpvar_55) {
    tmpvar_56 = 1.0;
  } else {
    tmpvar_56 = 0.0;
  };
  specularTerm_30 = (tmpvar_53 * tmpvar_56);
  mediump float x_57;
  x_57 = (1.0 - tmpvar_40);
  mediump vec4 tmpvar_58;
  tmpvar_58.w = 1.0;
  tmpvar_58.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_46)) + ((specularTerm_30 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_57 * x_57) * ((x_57 * x_57) * x_57)))
  )));
  gl_FragData[0] = tmpvar_58;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
bool u_xlatb8;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_15;
mediump float u_xlat16_16;
float u_xlat17;
lowp float u_xlat10_17;
mediump float u_xlat16_20;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = max(abs(u_xlat8.y), abs(u_xlat8.x));
    u_xlat17 = max(abs(u_xlat8.z), u_xlat17);
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.z);
    u_xlat17 = max(u_xlat17, 9.99999975e-06);
    u_xlat17 = u_xlat17 * _LightProjectionParams.w;
    u_xlat17 = _LightProjectionParams.y / u_xlat17;
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.x);
    vec4 txVec0 = vec4(u_xlat8.xyz,u_xlat17);
    u_xlat10_17 = texture(hlslcc_zcmp_ShadowMapTexture, txVec0);
    u_xlat16_4.x = (-_LightShadowData.x) + 1.0;
    u_xlat16_4.x = u_xlat10_17 * u_xlat16_4.x + _LightShadowData.x;
    u_xlat16_12 = (-u_xlat16_4.x) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_12 + u_xlat16_4.x;
    u_xlat0.x = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat17 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat17)).x;
    u_xlat17 = u_xlat16_4.x * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat17) * _LightColor.xyz;
    u_xlat17 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat2.xyz = vec3(u_xlat17) * u_xlat2.xyz;
    u_xlat5.xyz = (-u_xlat8.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat24 = dot(u_xlat5.xyz, u_xlat5.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat5.xyz = vec3(u_xlat24) * u_xlat5.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_6.xyz = vec3(u_xlat16_24) * u_xlat16_6.xyz;
    u_xlat24 = dot(u_xlat16_6.xyz, u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-u_xlat0.xyz), u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.x = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat5.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat5.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_4.x = (-u_xlat16_26) + 1.0;
    u_xlat16_12 = abs(u_xlat8.x) * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = abs(u_xlat8.x) * u_xlat16_4.x;
    u_xlat16_20 = -abs(u_xlat8.x) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_12 + u_xlat16_4.x;
    u_xlat16_8 = u_xlat16_4.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8.x = u_xlat24 * u_xlat16_8;
    u_xlat8.x = u_xlat8.x * 3.14159274;
    u_xlat8.x = max(u_xlat8.x, 9.99999975e-05);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat16_4.x = u_xlat0.x * u_xlat8.x;
    u_xlat16_12 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb8 = u_xlat16_12!=0.0;
#endif
    u_xlat8.x = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_4.x = u_xlat8.x * u_xlat16_4.x;
    u_xlat16_4.xyw = u_xlat3.xyz * u_xlat16_4.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_4.xyw = u_xlat16_4.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_20 * u_xlat16_20;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_20 = u_xlat16_7.x * u_xlat16_20 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_20 = u_xlat0.x * u_xlat16_20;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_20);
    SV_Target0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_4.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.x;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = mix (dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)), 1.0, tmpvar_14);
  atten_5 = (tmpvar_13.x * tmpvar_37);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_40;
  mediump float tmpvar_41;
  highp vec3 tmpvar_42;
  tmpvar_41 = gbuffer1_2.w;
  mediump vec3 tmpvar_43;
  tmpvar_43 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_42 = tmpvar_43;
  highp vec3 viewDir_44;
  viewDir_44 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_45;
  mediump float nv_46;
  highp float tmpvar_47;
  highp float smoothness_48;
  smoothness_48 = tmpvar_41;
  tmpvar_47 = (1.0 - smoothness_48);
  highp vec3 tmpvar_49;
  highp vec3 inVec_50;
  inVec_50 = (lightDir_6 + viewDir_44);
  tmpvar_49 = (inVec_50 * inversesqrt(max (0.001, 
    dot (inVec_50, inVec_50)
  )));
  highp float tmpvar_51;
  tmpvar_51 = abs(dot (tmpvar_42, viewDir_44));
  nv_46 = tmpvar_51;
  mediump float tmpvar_52;
  highp float tmpvar_53;
  tmpvar_53 = clamp (dot (tmpvar_42, lightDir_6), 0.0, 1.0);
  tmpvar_52 = tmpvar_53;
  highp float tmpvar_54;
  tmpvar_54 = clamp (dot (tmpvar_42, tmpvar_49), 0.0, 1.0);
  mediump float tmpvar_55;
  highp float tmpvar_56;
  tmpvar_56 = clamp (dot (lightDir_6, tmpvar_49), 0.0, 1.0);
  tmpvar_55 = tmpvar_56;
  mediump float perceptualRoughness_57;
  perceptualRoughness_57 = tmpvar_47;
  mediump float tmpvar_58;
  tmpvar_58 = (0.5 + ((2.0 * tmpvar_55) * (tmpvar_55 * perceptualRoughness_57)));
  mediump float x_59;
  x_59 = (1.0 - tmpvar_52);
  mediump float x_60;
  x_60 = (1.0 - nv_46);
  mediump float tmpvar_61;
  tmpvar_61 = (((1.0 + 
    ((tmpvar_58 - 1.0) * ((x_59 * x_59) * ((x_59 * x_59) * x_59)))
  ) * (1.0 + 
    ((tmpvar_58 - 1.0) * ((x_60 * x_60) * ((x_60 * x_60) * x_60)))
  )) * tmpvar_52);
  highp float tmpvar_62;
  tmpvar_62 = max ((tmpvar_47 * tmpvar_47), 0.002);
  mediump float tmpvar_63;
  mediump float roughness_64;
  roughness_64 = tmpvar_62;
  tmpvar_63 = (0.5 / ((
    (tmpvar_52 * ((nv_46 * (1.0 - roughness_64)) + roughness_64))
   + 
    (nv_46 * ((tmpvar_52 * (1.0 - roughness_64)) + roughness_64))
  ) + 1e-5));
  highp float tmpvar_65;
  tmpvar_65 = (tmpvar_62 * tmpvar_62);
  highp float tmpvar_66;
  tmpvar_66 = (((
    (tmpvar_54 * tmpvar_65)
   - tmpvar_54) * tmpvar_54) + 1.0);
  highp float tmpvar_67;
  tmpvar_67 = ((tmpvar_63 * (
    (0.3183099 * tmpvar_65)
   / 
    ((tmpvar_66 * tmpvar_66) + 1e-7)
  )) * 3.141593);
  specularTerm_45 = tmpvar_67;
  mediump float tmpvar_68;
  tmpvar_68 = max (0.0, (sqrt(
    max (0.0001, specularTerm_45)
  ) * tmpvar_52));
  specularTerm_45 = tmpvar_68;
  bvec3 tmpvar_69;
  tmpvar_69 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_70;
  tmpvar_70 = any(tmpvar_69);
  highp float tmpvar_71;
  if (tmpvar_70) {
    tmpvar_71 = 1.0;
  } else {
    tmpvar_71 = 0.0;
  };
  specularTerm_45 = (tmpvar_68 * tmpvar_71);
  mediump float x_72;
  x_72 = (1.0 - tmpvar_55);
  mediump vec4 tmpvar_73;
  tmpvar_73.w = 1.0;
  tmpvar_73.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_61)) + ((specularTerm_45 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_72 * x_72) * ((x_72 * x_72) * x_72)))
  )));
  gl_FragData[0] = tmpvar_73;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec3 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
bool u_xlatb8;
mediump float u_xlat16_13;
mediump vec3 u_xlat16_15;
mediump float u_xlat16_16;
float u_xlat17;
mediump float u_xlat16_21;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = max(abs(u_xlat8.y), abs(u_xlat8.x));
    u_xlat17 = max(abs(u_xlat8.z), u_xlat17);
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.z);
    u_xlat17 = max(u_xlat17, 9.99999975e-06);
    u_xlat17 = u_xlat17 * _LightProjectionParams.w;
    u_xlat17 = _LightProjectionParams.y / u_xlat17;
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.x);
    u_xlat3.xyz = u_xlat8.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    vec4 txVec0 = vec4(u_xlat3.xyz,u_xlat17);
    u_xlat3.x = texture(hlslcc_zcmp_ShadowMapTexture, txVec0);
    u_xlat4.xyz = u_xlat8.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    vec4 txVec1 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.y = texture(hlslcc_zcmp_ShadowMapTexture, txVec1);
    u_xlat4.xyz = u_xlat8.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    vec4 txVec2 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.z = texture(hlslcc_zcmp_ShadowMapTexture, txVec2);
    u_xlat4.xyz = u_xlat8.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    vec4 txVec3 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.w = texture(hlslcc_zcmp_ShadowMapTexture, txVec3);
    u_xlat17 = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_5.x = (-_LightShadowData.x) + 1.0;
    u_xlat16_5.x = u_xlat17 * u_xlat16_5.x + _LightShadowData.x;
    u_xlat16_13 = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_13 + u_xlat16_5.x;
    u_xlat0.x = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat17 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat17)).x;
    u_xlat17 = u_xlat16_5.x * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat17) * _LightColor.xyz;
    u_xlat17 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat2.xyz = vec3(u_xlat17) * u_xlat2.xyz;
    u_xlat4.xyz = (-u_xlat8.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_6.xyz = vec3(u_xlat16_24) * u_xlat16_6.xyz;
    u_xlat24 = dot(u_xlat16_6.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-u_xlat0.xyz), u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.x = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat4.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat4.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_5.x = (-u_xlat16_26) + 1.0;
    u_xlat16_13 = abs(u_xlat8.x) * u_xlat16_5.x + u_xlat16_26;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_5.x + u_xlat16_26;
    u_xlat16_5.x = abs(u_xlat8.x) * u_xlat16_5.x;
    u_xlat16_21 = -abs(u_xlat8.x) + 1.0;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_13 + u_xlat16_5.x;
    u_xlat16_8 = u_xlat16_5.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8.x = u_xlat24 * u_xlat16_8;
    u_xlat8.x = u_xlat8.x * 3.14159274;
    u_xlat8.x = max(u_xlat8.x, 9.99999975e-05);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat16_5.x = u_xlat0.x * u_xlat8.x;
    u_xlat16_13 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_13!=0.0);
#else
    u_xlatb8 = u_xlat16_13!=0.0;
#endif
    u_xlat8.x = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_5.x = u_xlat8.x * u_xlat16_5.x;
    u_xlat16_5.xyw = u_xlat3.xyz * u_xlat16_5.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_5.xyw = u_xlat16_5.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_21 * u_xlat16_21;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_21 = u_xlat16_7.x * u_xlat16_21 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_7.x;
    u_xlat16_21 = u_xlat0.x * u_xlat16_21;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_21);
    SV_Target0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_5.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.x;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = mix (tmpvar_21, 1.0, tmpvar_14);
  atten_5 = (tmpvar_13.x * tmpvar_22);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_9;
  highp vec4 tmpvar_24;
  tmpvar_24.w = -8.0;
  tmpvar_24.xyz = (unity_WorldToLight * tmpvar_23).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_24.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump float tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_28 = gbuffer1_2.w;
  mediump vec3 tmpvar_30;
  tmpvar_30 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_29 = tmpvar_30;
  highp vec3 viewDir_31;
  viewDir_31 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_32;
  mediump float nv_33;
  highp float tmpvar_34;
  highp float smoothness_35;
  smoothness_35 = tmpvar_28;
  tmpvar_34 = (1.0 - smoothness_35);
  highp vec3 tmpvar_36;
  highp vec3 inVec_37;
  inVec_37 = (lightDir_6 + viewDir_31);
  tmpvar_36 = (inVec_37 * inversesqrt(max (0.001, 
    dot (inVec_37, inVec_37)
  )));
  highp float tmpvar_38;
  tmpvar_38 = abs(dot (tmpvar_29, viewDir_31));
  nv_33 = tmpvar_38;
  mediump float tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp (dot (tmpvar_29, lightDir_6), 0.0, 1.0);
  tmpvar_39 = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = clamp (dot (tmpvar_29, tmpvar_36), 0.0, 1.0);
  mediump float tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = clamp (dot (lightDir_6, tmpvar_36), 0.0, 1.0);
  tmpvar_42 = tmpvar_43;
  mediump float perceptualRoughness_44;
  perceptualRoughness_44 = tmpvar_34;
  mediump float tmpvar_45;
  tmpvar_45 = (0.5 + ((2.0 * tmpvar_42) * (tmpvar_42 * perceptualRoughness_44)));
  mediump float x_46;
  x_46 = (1.0 - tmpvar_39);
  mediump float x_47;
  x_47 = (1.0 - nv_33);
  mediump float tmpvar_48;
  tmpvar_48 = (((1.0 + 
    ((tmpvar_45 - 1.0) * ((x_46 * x_46) * ((x_46 * x_46) * x_46)))
  ) * (1.0 + 
    ((tmpvar_45 - 1.0) * ((x_47 * x_47) * ((x_47 * x_47) * x_47)))
  )) * tmpvar_39);
  highp float tmpvar_49;
  tmpvar_49 = max ((tmpvar_34 * tmpvar_34), 0.002);
  mediump float tmpvar_50;
  mediump float roughness_51;
  roughness_51 = tmpvar_49;
  tmpvar_50 = (0.5 / ((
    (tmpvar_39 * ((nv_33 * (1.0 - roughness_51)) + roughness_51))
   + 
    (nv_33 * ((tmpvar_39 * (1.0 - roughness_51)) + roughness_51))
  ) + 1e-5));
  highp float tmpvar_52;
  tmpvar_52 = (tmpvar_49 * tmpvar_49);
  highp float tmpvar_53;
  tmpvar_53 = (((
    (tmpvar_41 * tmpvar_52)
   - tmpvar_41) * tmpvar_41) + 1.0);
  highp float tmpvar_54;
  tmpvar_54 = ((tmpvar_50 * (
    (0.3183099 * tmpvar_52)
   / 
    ((tmpvar_53 * tmpvar_53) + 1e-7)
  )) * 3.141593);
  specularTerm_32 = tmpvar_54;
  mediump float tmpvar_55;
  tmpvar_55 = max (0.0, (sqrt(
    max (0.0001, specularTerm_32)
  ) * tmpvar_39));
  specularTerm_32 = tmpvar_55;
  bvec3 tmpvar_56;
  tmpvar_56 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_57;
  tmpvar_57 = any(tmpvar_56);
  highp float tmpvar_58;
  if (tmpvar_57) {
    tmpvar_58 = 1.0;
  } else {
    tmpvar_58 = 0.0;
  };
  specularTerm_32 = (tmpvar_55 * tmpvar_58);
  mediump float x_59;
  x_59 = (1.0 - tmpvar_42);
  mediump vec4 tmpvar_60;
  tmpvar_60.w = 1.0;
  tmpvar_60.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_48)) + ((specularTerm_32 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_59 * x_59) * ((x_59 * x_59) * x_59)))
  )));
  gl_FragData[0] = tmpvar_60;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
bool u_xlatb8;
mediump float u_xlat16_12;
mediump vec3 u_xlat16_15;
mediump float u_xlat16_16;
float u_xlat17;
lowp float u_xlat10_17;
mediump float u_xlat16_20;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat17 = max(abs(u_xlat8.y), abs(u_xlat8.x));
    u_xlat17 = max(abs(u_xlat8.z), u_xlat17);
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.z);
    u_xlat17 = max(u_xlat17, 9.99999975e-06);
    u_xlat17 = u_xlat17 * _LightProjectionParams.w;
    u_xlat17 = _LightProjectionParams.y / u_xlat17;
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.x);
    vec4 txVec0 = vec4(u_xlat8.xyz,u_xlat17);
    u_xlat10_17 = texture(hlslcc_zcmp_ShadowMapTexture, txVec0);
    u_xlat16_4.x = (-_LightShadowData.x) + 1.0;
    u_xlat16_4.x = u_xlat10_17 * u_xlat16_4.x + _LightShadowData.x;
    u_xlat16_12 = (-u_xlat16_4.x) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_12 + u_xlat16_4.x;
    u_xlat0.x = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat17 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat17)).x;
    u_xlat17 = u_xlat16_4.x * u_xlat17;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat25 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat17 = u_xlat25 * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat17) * _LightColor.xyz;
    u_xlat17 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat2.xyz = vec3(u_xlat17) * u_xlat2.xyz;
    u_xlat5.xyz = (-u_xlat8.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat24 = dot(u_xlat5.xyz, u_xlat5.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat5.xyz = vec3(u_xlat24) * u_xlat5.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_6.xyz = vec3(u_xlat16_24) * u_xlat16_6.xyz;
    u_xlat24 = dot(u_xlat16_6.xyz, u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-u_xlat0.xyz), u_xlat5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.x = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat5.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat5.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_4.x = (-u_xlat16_26) + 1.0;
    u_xlat16_12 = abs(u_xlat8.x) * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_4.x + u_xlat16_26;
    u_xlat16_4.x = abs(u_xlat8.x) * u_xlat16_4.x;
    u_xlat16_20 = -abs(u_xlat8.x) + 1.0;
    u_xlat16_4.x = u_xlat0.x * u_xlat16_12 + u_xlat16_4.x;
    u_xlat16_8 = u_xlat16_4.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8.x = u_xlat24 * u_xlat16_8;
    u_xlat8.x = u_xlat8.x * 3.14159274;
    u_xlat8.x = max(u_xlat8.x, 9.99999975e-05);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat16_4.x = u_xlat0.x * u_xlat8.x;
    u_xlat16_12 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_12!=0.0);
#else
    u_xlatb8 = u_xlat16_12!=0.0;
#endif
    u_xlat8.x = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_4.x = u_xlat8.x * u_xlat16_4.x;
    u_xlat16_4.xyw = u_xlat3.xyz * u_xlat16_4.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_4.xyw = u_xlat16_4.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_20 * u_xlat16_20;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_20 = u_xlat16_7.x * u_xlat16_20 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_20 = u_xlat16_20 * u_xlat16_7.x;
    u_xlat16_20 = u_xlat0.x * u_xlat16_20;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_20);
    SV_Target0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_4.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.x;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-5, 6.030863e-8));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = mix (dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)), 1.0, tmpvar_14);
  atten_5 = (tmpvar_13.x * tmpvar_37);
  highp vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = tmpvar_9;
  highp vec4 tmpvar_39;
  tmpvar_39.w = -8.0;
  tmpvar_39.xyz = (unity_WorldToLight * tmpvar_38).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_39.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_42;
  mediump float tmpvar_43;
  highp vec3 tmpvar_44;
  tmpvar_43 = gbuffer1_2.w;
  mediump vec3 tmpvar_45;
  tmpvar_45 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  tmpvar_44 = tmpvar_45;
  highp vec3 viewDir_46;
  viewDir_46 = -(normalize((tmpvar_9 - _WorldSpaceCameraPos)));
  mediump float specularTerm_47;
  mediump float nv_48;
  highp float tmpvar_49;
  highp float smoothness_50;
  smoothness_50 = tmpvar_43;
  tmpvar_49 = (1.0 - smoothness_50);
  highp vec3 tmpvar_51;
  highp vec3 inVec_52;
  inVec_52 = (lightDir_6 + viewDir_46);
  tmpvar_51 = (inVec_52 * inversesqrt(max (0.001, 
    dot (inVec_52, inVec_52)
  )));
  highp float tmpvar_53;
  tmpvar_53 = abs(dot (tmpvar_44, viewDir_46));
  nv_48 = tmpvar_53;
  mediump float tmpvar_54;
  highp float tmpvar_55;
  tmpvar_55 = clamp (dot (tmpvar_44, lightDir_6), 0.0, 1.0);
  tmpvar_54 = tmpvar_55;
  highp float tmpvar_56;
  tmpvar_56 = clamp (dot (tmpvar_44, tmpvar_51), 0.0, 1.0);
  mediump float tmpvar_57;
  highp float tmpvar_58;
  tmpvar_58 = clamp (dot (lightDir_6, tmpvar_51), 0.0, 1.0);
  tmpvar_57 = tmpvar_58;
  mediump float perceptualRoughness_59;
  perceptualRoughness_59 = tmpvar_49;
  mediump float tmpvar_60;
  tmpvar_60 = (0.5 + ((2.0 * tmpvar_57) * (tmpvar_57 * perceptualRoughness_59)));
  mediump float x_61;
  x_61 = (1.0 - tmpvar_54);
  mediump float x_62;
  x_62 = (1.0 - nv_48);
  mediump float tmpvar_63;
  tmpvar_63 = (((1.0 + 
    ((tmpvar_60 - 1.0) * ((x_61 * x_61) * ((x_61 * x_61) * x_61)))
  ) * (1.0 + 
    ((tmpvar_60 - 1.0) * ((x_62 * x_62) * ((x_62 * x_62) * x_62)))
  )) * tmpvar_54);
  highp float tmpvar_64;
  tmpvar_64 = max ((tmpvar_49 * tmpvar_49), 0.002);
  mediump float tmpvar_65;
  mediump float roughness_66;
  roughness_66 = tmpvar_64;
  tmpvar_65 = (0.5 / ((
    (tmpvar_54 * ((nv_48 * (1.0 - roughness_66)) + roughness_66))
   + 
    (nv_48 * ((tmpvar_54 * (1.0 - roughness_66)) + roughness_66))
  ) + 1e-5));
  highp float tmpvar_67;
  tmpvar_67 = (tmpvar_64 * tmpvar_64);
  highp float tmpvar_68;
  tmpvar_68 = (((
    (tmpvar_56 * tmpvar_67)
   - tmpvar_56) * tmpvar_56) + 1.0);
  highp float tmpvar_69;
  tmpvar_69 = ((tmpvar_65 * (
    (0.3183099 * tmpvar_67)
   / 
    ((tmpvar_68 * tmpvar_68) + 1e-7)
  )) * 3.141593);
  specularTerm_47 = tmpvar_69;
  mediump float tmpvar_70;
  tmpvar_70 = max (0.0, (sqrt(
    max (0.0001, specularTerm_47)
  ) * tmpvar_54));
  specularTerm_47 = tmpvar_70;
  bvec3 tmpvar_71;
  tmpvar_71 = bvec3(gbuffer1_2.xyz);
  bool tmpvar_72;
  tmpvar_72 = any(tmpvar_71);
  highp float tmpvar_73;
  if (tmpvar_72) {
    tmpvar_73 = 1.0;
  } else {
    tmpvar_73 = 0.0;
  };
  specularTerm_47 = (tmpvar_70 * tmpvar_73);
  mediump float x_74;
  x_74 = (1.0 - tmpvar_57);
  mediump vec4 tmpvar_75;
  tmpvar_75.w = 1.0;
  tmpvar_75.xyz = ((gbuffer0_3.xyz * (tmpvar_4 * tmpvar_63)) + ((specularTerm_47 * tmpvar_4) * (gbuffer1_2.xyz + 
    ((1.0 - gbuffer1_2.xyz) * ((x_74 * x_74) * ((x_74 * x_74) * x_74)))
  )));
  gl_FragData[0] = tmpvar_75;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCubeShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec3 u_xlat4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
bool u_xlatb8;
mediump float u_xlat16_13;
mediump vec3 u_xlat16_15;
mediump float u_xlat16_16;
float u_xlat17;
mediump float u_xlat16_21;
mediump float u_xlat16_23;
float u_xlat24;
mediump float u_xlat16_24;
float u_xlat25;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat24 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat17 = max(abs(u_xlat8.y), abs(u_xlat8.x));
    u_xlat17 = max(abs(u_xlat8.z), u_xlat17);
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.z);
    u_xlat17 = max(u_xlat17, 9.99999975e-06);
    u_xlat17 = u_xlat17 * _LightProjectionParams.w;
    u_xlat17 = _LightProjectionParams.y / u_xlat17;
    u_xlat17 = u_xlat17 + (-_LightProjectionParams.x);
    u_xlat3.xyz = u_xlat8.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    vec4 txVec0 = vec4(u_xlat3.xyz,u_xlat17);
    u_xlat3.x = texture(hlslcc_zcmp_ShadowMapTexture, txVec0);
    u_xlat4.xyz = u_xlat8.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    vec4 txVec1 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.y = texture(hlslcc_zcmp_ShadowMapTexture, txVec1);
    u_xlat4.xyz = u_xlat8.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    vec4 txVec2 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.z = texture(hlslcc_zcmp_ShadowMapTexture, txVec2);
    u_xlat4.xyz = u_xlat8.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    vec4 txVec3 = vec4(u_xlat4.xyz,u_xlat17);
    u_xlat3.w = texture(hlslcc_zcmp_ShadowMapTexture, txVec3);
    u_xlat17 = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_5.x = (-_LightShadowData.x) + 1.0;
    u_xlat16_5.x = u_xlat17 * u_xlat16_5.x + _LightShadowData.x;
    u_xlat16_13 = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_13 + u_xlat16_5.x;
    u_xlat0.x = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat17 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat17)).x;
    u_xlat17 = u_xlat16_5.x * u_xlat17;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat25 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat17 = u_xlat25 * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat17) * _LightColor.xyz;
    u_xlat17 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat2.xyz = vec3(u_xlat17) * u_xlat2.xyz;
    u_xlat4.xyz = (-u_xlat8.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat24 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = max(u_xlat24, 0.00100000005);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_24 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_24 = inversesqrt(u_xlat16_24);
    u_xlat16_6.xyz = vec3(u_xlat16_24) * u_xlat16_6.xyz;
    u_xlat24 = dot(u_xlat16_6.xyz, u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat24 = min(max(u_xlat24, 0.0), 1.0);
#else
    u_xlat24 = clamp(u_xlat24, 0.0, 1.0);
#endif
    u_xlat17 = dot((-u_xlat0.xyz), u_xlat4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat17 = min(max(u_xlat17, 0.0), 1.0);
#else
    u_xlat17 = clamp(u_xlat17, 0.0, 1.0);
#endif
    u_xlat0.x = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat8.x = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_26 = max(u_xlat16_26, 0.00200000009);
    u_xlat16_27 = u_xlat16_26 * u_xlat16_26;
    u_xlat4.x = u_xlat24 * u_xlat16_27 + (-u_xlat24);
    u_xlat24 = u_xlat4.x * u_xlat24 + 1.0;
    u_xlat24 = u_xlat24 * u_xlat24 + 1.00000001e-07;
    u_xlat16_27 = u_xlat16_27 * 0.318309873;
    u_xlat24 = u_xlat16_27 / u_xlat24;
    u_xlat16_5.x = (-u_xlat16_26) + 1.0;
    u_xlat16_13 = abs(u_xlat8.x) * u_xlat16_5.x + u_xlat16_26;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_5.x + u_xlat16_26;
    u_xlat16_5.x = abs(u_xlat8.x) * u_xlat16_5.x;
    u_xlat16_21 = -abs(u_xlat8.x) + 1.0;
    u_xlat16_5.x = u_xlat0.x * u_xlat16_13 + u_xlat16_5.x;
    u_xlat16_8 = u_xlat16_5.x + 9.99999975e-06;
    u_xlat16_8 = 0.5 / u_xlat16_8;
    u_xlat8.x = u_xlat24 * u_xlat16_8;
    u_xlat8.x = u_xlat8.x * 3.14159274;
    u_xlat8.x = max(u_xlat8.x, 9.99999975e-05);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat16_5.x = u_xlat0.x * u_xlat8.x;
    u_xlat16_13 = dot(u_xlat10_2.xyz, u_xlat10_2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlatb8 = !!(u_xlat16_13!=0.0);
#else
    u_xlatb8 = u_xlat16_13!=0.0;
#endif
    u_xlat8.x = u_xlatb8 ? 1.0 : float(0.0);
    u_xlat16_5.x = u_xlat8.x * u_xlat16_5.x;
    u_xlat16_5.xyw = u_xlat3.xyz * u_xlat16_5.xxx;
    u_xlat16_7.x = (-u_xlat17) + 1.0;
    u_xlat16_15.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x;
    u_xlat16_15.xyz = (-u_xlat10_2.xyz) + vec3(1.0, 1.0, 1.0);
    u_xlat16_7.xyz = u_xlat16_15.xyz * u_xlat16_7.xxx + u_xlat10_2.xyz;
    u_xlat16_5.xyw = u_xlat16_5.xyw * u_xlat16_7.xyz;
    u_xlat16_7.x = u_xlat16_21 * u_xlat16_21;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_7.x;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat17 + u_xlat17;
    u_xlat16_7.x = u_xlat17 * u_xlat16_7.x;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_16 + -0.5;
    u_xlat16_21 = u_xlat16_7.x * u_xlat16_21 + 1.0;
    u_xlat16_15.x = (-u_xlat0.x) + 1.0;
    u_xlat16_23 = u_xlat16_15.x * u_xlat16_15.x;
    u_xlat16_23 = u_xlat16_23 * u_xlat16_23;
    u_xlat16_15.x = u_xlat16_15.x * u_xlat16_23;
    u_xlat16_7.x = u_xlat16_7.x * u_xlat16_15.x + 1.0;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_7.x;
    u_xlat16_21 = u_xlat0.x * u_xlat16_21;
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_21);
    SV_Target0.xyz = u_xlat10_1.xyw * u_xlat16_7.xyz + u_xlat16_5.xyw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "POINT" }
""
}
SubProgram "gles3 " {
Keywords { "POINT" }
""
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles " {
Keywords { "SPOT" }
""
}
SubProgram "gles3 " {
Keywords { "SPOT" }
""
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
}
}
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Stencil {
   ReadMask 0
   CompFront Equal
   PassFront Keep
   FailFront Keep
   ZFailFront Keep
   CompBack Equal
   PassBack Keep
   FailBack Keep
   ZFailBack Keep
  }
  GpuProgramID 129378
Program "vp" {
SubProgram "gles " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _LightBuffer;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = -(log2(texture2D (_LightBuffer, xlv_TEXCOORD0)));
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
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
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _LightBuffer;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
void main()
{
    u_xlat10_0 = texture(_LightBuffer, vs_TEXCOORD0.xy);
    u_xlat16_0 = log2(u_xlat10_0);
    SV_Target0 = (-u_xlat16_0);
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
}
}