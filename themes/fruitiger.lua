return {
    background={
        color="#e1e0e0",
        image=lg.newImage("assets/aero.jpg")
    },

    font={
        color={
            default="#ffffff",
            highlight="#ffffff"
        },


        regular=lg.newFont("assets/fonts/aero.ttf",24),
        h1=lg.newFont("assets/fonts/aero.ttf",26)
    },

    panel={
        radius=100,

        fill={
            color="#3ef37d",
            opacity=0.5,
            --[[highlight={
                color="#7DE87E",
                gradient={
                    "#4adce4",
                    "#a373f0"
                }
            }]]
        },


        outline={
            thickness=3,
            color="#ffffff",
            opacity=0.4,
            highlight={
                thickness=2,
                color="#ffffff",
                opacity=0.5
            }
        }

        
    },

    icons={
        overlayColor="#fbfbfb",
        opacity=1
    }
}