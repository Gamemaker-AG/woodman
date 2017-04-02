extern number time;
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec2 relative = screen_coords / vec2(max(love_ScreenSize.y, love_ScreenSize.x));
    number sun_y = 1.35 - (log(time + 2) + 4) * 0.1;
    vec2 sun = vec2(0.1 - (sun_y * 0.1), sun_y);
    vec4 suncolor = vec4(0, 0, 0, 1);
    if (length(screen_coords - (sun * love_ScreenSize.y)) < 100) {
        number dist = length(relative - sun);
        return vec4(1, 1, 0.4, 1);
    }
    vec4 sky_color = vec4(
        relative.y + time * 0.1,
        1 - relative.y * 0.7,
        1 - relative.y + 0.3, 1
    );
    return sky_color + suncolor;
}
