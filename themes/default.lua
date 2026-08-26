return {
    background={
        color="#e1e0e0",
        --image=lg.newImage("assets/water.jpg")
    },

    font={
        color="#7A7287",

        regular=lg.newFont("assets/fonts/contb.ttf",24)
    },

    panel={
        radius=100,

        fill={
            color="#ffffff",
            opacity=1,
            highlight={
                gradient={
                    "#5ED4F8",
                    "#cb82ff"
                }
            }
        },


        --[[outline={
            thickness=4,
            color="#7A7287",
            opacity=1
        },]]

        

        --[[shadow={
            color="#000000",
            offsetX=0,
            offsetY=3,
            opacity=0.8,
            radius=10
        }]]
    }
}