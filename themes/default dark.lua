return {
    background={
        color="#39343f",
        --image=lg.newImage("assets/aero.jpg")
    },

    font={
        color={
            default="#efeded",
            highlight="#ffffff"
        },


        regular=lg.newFont("assets/fonts/contb.ttf",24),
        h1=lg.newFont("assets/fonts/contb.ttf",26)
    },

    panel={
        radius=100,

        fill={
            color="#1d1a22",
            opacity=1,
            highlight={
                color="#1d1a22",
                gradient={
                    "#4adce4",
                    "#a373f0"
                }
            }
        },


        --[[outline={
            thickness=4,
            color="#7A7287",
            opacity=1,
            highlight={
                thickness=2,
                color="#ffffff",
                opacity=0.5
            }
        }]]
    },

    icons={
        overlayColor="#efeded",
        opacity=1
    }
}