#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] half4 sandyGradient(
    float2 position,
    half4 color,
    float2 size,
    float time,
    half4 colorA,
    half4 colorB,
    half4 colorC
) {
    float2 uv = position / size;
    float t = time * 0.08;

    float wave1 = sin((uv.x * 2.6) + t) + sin((uv.y * 2.1) - t * 0.8);
    float wave2 = sin((uv.x + uv.y) * 1.8 + t * 0.6);
    float blend = clamp(0.5 + 0.25 * wave1 + 0.25 * wave2, 0.0, 1.0);
    float sheen = 0.5 + 0.5 * sin((uv.y * 3.0) - t * 1.1);

    half4 base = mix(colorA, colorB, half(blend));
    base = mix(base, colorC, half(sheen * 0.5));

    float grain = fract(sin(dot(position, float2(12.9898, 78.233))) * 43758.5453);
    base.rgb += half3(half((grain - 0.5) * 0.05));
    base.rgb += half3(half((1.0 - uv.y) * 0.06));

    return half4(base.rgb, 1.0h);
}
