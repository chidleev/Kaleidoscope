uniform float aspect;
uniform vec2 offset;
uniform float zoom;

varying vec2 pixelPosition;

void main()
{
    pixelPosition = vec2(position.x * aspect, position.y) * zoom + offset;
    gl_Position = vec4(position, 1.0);
}