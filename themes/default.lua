return {
    background={
        color="#e1e0e0",
        --image=lg.newImage("assets/aero.jpg")
    },

    font={
        color={
            default="#7A7287",
            highlight="#ffffff"
        },


        regular=lg.newFont("assets/fonts/contb.ttf",24*globalScale),
        h1=lg.newFont("assets/fonts/contb.ttf",26*globalScale)
    },

    panel={
        radius=100,

        fill={
            color="#ffffff",
            opacity=1,
            highlight={
                color="#4adce4",
                gradient={
                    "#60BDFF",
                    "#B6E98C"
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
        overlayColor="#7A7287",
        opacity=1
    }
}