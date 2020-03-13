extern number leftLimit;
extern number rightLimit;
extern number noteWidth;

vec4 effect(vec4 color, Image texture, vec2 tc, vec2 screen)
{
  number leftAlpha = min( max(0.0, screen.x - (leftLimit - noteWidth)) / noteWidth, 1.0);
  number rightAlpha = min( max(0.0, rightLimit - screen.x ) / noteWidth, 1.0);
  return vec4(color.rgb, leftAlpha * rightAlpha * color.a) * Texel(texture, tc);
}