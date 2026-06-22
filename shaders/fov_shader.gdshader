shader_type canvas_item;
render_mode unshaded;

// RECTÁNGULO
group_uniforms rectangle;
instance uniform bool use_rectangle = false;
instance uniform vec2 rectangle_size = vec2(0.5, 0.2); // X = Largo (hacia el frente), Y = Alto (grosor)
instance uniform float rectangle_rotation : hint_range(0.0, 360.0) = 0.0;
group_uniforms;

// CONO
group_uniforms cone;
instance uniform float cone_angle : hint_range(0.1, 360.0) = 90.0;
instance uniform float start_angle : hint_range(0.0, 360.0) = 0.0;
group_uniforms;

// GENERALES
group_uniforms general;
instance uniform float fade_intensity : hint_range(0.0, 4.0) = 3.0;
instance uniform float circle_radius : hint_range(0.0, 0.5) = 0.5;
instance uniform float inner_circle_alpha : hint_range(0.0, 1.0) = 0.8;
instance uniform float outline_thickness : hint_range(0.0, 0.1) = 0.015;

instance uniform vec4 custom_color : source_color = vec4(0.0, 0.898, 1.0, 0.294);
instance uniform vec4 custom_outline_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);

const float cone_scale = 1.0;
group_uniforms;

// Función auxiliar para un step con antialiasing basado en el tamaño del píxel en pantalla
float aastep(float edge, float value) {
    float afwidth = fwidth(value);
    return smoothstep(edge - afwidth, edge + afwidth, value);
}

void fragment() {

    vec2 uv = (UV - vec2(0.5)) * cone_scale + vec2(0.5);
    vec2 centered_uv = uv - vec2(0.5);

    float radius = length(centered_uv);

    //--------------------------------------------------
    // MÁSCARA PRINCIPAL (CONO O RECTÁNGULO)
    //--------------------------------------------------

    float within_shape = 0.0;
    float shape_outline = 0.0;
    float final_circle_radius = 1.0;

    if (!use_rectangle) {
        final_circle_radius = circle_radius;
        
        // Si el ángulo es 360 (o muy cercano), evitamos calcular el cono para que no deje líneas intermedias
        if (cone_angle >= 359.9) {
            within_shape = 1.0;
            shape_outline = 0.0;
        } else {
            float angle = atan(centered_uv.y, centered_uv.x);

            float cone_radians = radians(cone_angle / 2.0);
            float start_radians = radians(start_angle);

            angle -= start_radians;
            angle = mod(angle + PI, 2.0 * PI) - PI;

            // Antialiasing en los bordes angulares del cono
            float abs_angle = abs(angle);
            within_shape = 1.0 - aastep(cone_radians, abs_angle);

            const float epsilon = 0.0001;

            if (abs(cone_angle) > epsilon) {
                float thickness_rad = radians(outline_thickness * 180.0 / PI);
                
                // Reemplazo de los steps del outline por curvas suaves de un píxel
                shape_outline = 
                    aastep(cone_radians - thickness_rad, abs_angle) 
                    - aastep(cone_radians, abs_angle);
            }
        }

    } else {

        // Rotación del rectángulo
        float rot = radians(rectangle_rotation);

        mat2 rot_mat = mat2(
            vec2(cos(rot), -sin(rot)),
            vec2(sin(rot),  cos(rot))
        );

        // Rotamos las coordenadas respecto al centro (0,0)
        vec2 local_uv = rot_mat * centered_uv;

        // Modificamos el tamaño con la escala global
        vec2 scaled_size = rectangle_size * cone_scale;
        float half_height = scaled_size.y * 0.5;

        // Antialiasing individual para cada borde del rectángulo con aastep
        float border_left   = aastep(0.0, local_uv.x);
        float border_right  = 1.0 - aastep(scaled_size.x, local_uv.x);
        float border_top    = 1.0 - aastep(half_height, local_uv.y);
        float border_bottom = aastep(-half_height, local_uv.y);

        within_shape = border_left * border_right * border_top * border_bottom;

        // Bordes internos usando restas de cajas suavizadas
        float inner_left   = aastep(outline_thickness, local_uv.x);
        float inner_right  = 1.0 - aastep(scaled_size.x - outline_thickness, local_uv.x);
        float inner_top    = 1.0 - aastep(half_height - outline_thickness, local_uv.y);
        float inner_bottom = aastep(-half_height + outline_thickness, local_uv.y);

        float inner = inner_left * inner_right * inner_top * inner_bottom;
        shape_outline = max(0.0, within_shape - inner);
    }

    //--------------------------------------------------
    // CÍRCULO EXTERNO
    //--------------------------------------------------

    float scaled_circle_radius = final_circle_radius * cone_scale;

    // Antialiasing en la máscara circular y su borde
    float within_circle = 1.0 - aastep(scaled_circle_radius, radius);

    float outline =
        aastep(scaled_circle_radius - outline_thickness, radius)
        - aastep(scaled_circle_radius, radius);

    //--------------------------------------------------
    // FADE
    //--------------------------------------------------

    float fade =
        smoothstep(
            0.0,
            1.0,
            (radius / cone_scale) * fade_intensity
        );

    //--------------------------------------------------
    // RESULTADO
    //--------------------------------------------------

    float combined_outline =
        max(outline, shape_outline);

    vec4 color = vec4(
        custom_color.rgb,
        inner_circle_alpha *
        fade *
        within_shape *
        within_circle *
        custom_color.a
    );

    vec4 outline_color = vec4(
        custom_outline_color.rgb,
        combined_outline *
        fade *
        within_shape *
        within_circle
    );

    COLOR = mix(color, outline_color, outline_color.a);
}