uniform float XScale;
uniform vec2 offset;
uniform float zoom;

varying vec2 pixelPos;

void main()
{
    pixelPos = vec2(position.x * XScale, position.y) * zoom + offset;

    gl_Position = vec4(position, 1.0);
}