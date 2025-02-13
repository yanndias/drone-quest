local TComponent = require 'components/TComponent'

return {
    New = function()
        _G.Camera = TComponent.New 'Camera' -- cria a variável no GlobalScope, nesse caso
        local self = Camera
        function Camera.Init(e, args) 
            Camera.Speed = 5
            Camera.Zoom = 1
            Camera.Target = Game.Physis.getObject 'Player'
            bg = Game.getObject 'Background'
        end

        function Camera.setZoom(zoom)
            Camera.Zoom = zoom
        end

        function Camera.ScreenToWorld(x,y)
            return (x+Camera.Pos.X)/Camera.Zoom, (y-Camera.Pos.Y)/Camera.Zoom
        end

        function Camera.WorldToScreen(x, y)
            return (x-Camera.Pos.X)/Camera.Zoom, (y+Camera.Pos.Y)/Camera.Zoom
        end
        
        function Camera.Update(dt)
            local delta = { 
                -- distancia entre o player e a origem atual e correção atenuada
                X = math.floor(Camera.Pos.X - (Camera.Target.Pos.X - Screen.Width/2)),  
                Y = math.floor(Camera.Pos.Y + (Camera.Target.Pos.Y - Screen.Height/2)) 
            }
            local target = {
            -- posição que a origem vai seguir
            Y = (Camera.Pos.Y - (delta.Y * Camera.Speed * dt)),
            X = (Camera.Pos.X - (delta.X * Camera.Speed * dt))
            }
            -- correções, caso o objeto esteja nas margens do mapa
            target.Y, target.X = ((target.Y < 0) and target.Y or 0), ((target.X > 0) and target.X or 0)
            target.Y = (-target.Y+Screen.Height > bg.Image:getHeight()) and -(bg.Image:getHeight() - Screen.Height) or target.Y
            target.X = (target.X > bg.Image:getWidth()-Screen.Width) and (bg.Image:getWidth()-Screen.Width) or target.X
            Camera.Pos = target
            --[[ 
            a origem do plano segue de forma atenuada um objeto passado como Camera.Target, 
            o que simula o comportamento de uma camera.
            ]]
        end

        function Camera.Set(e) 
            love.graphics.scale(Camera.Zoom,Camera.Zoom) 
            love.graphics.translate(-Camera.Pos.X, Camera.Pos.Y)
            Game.LightWorld.Set()
        end

        function Camera.Unset(e)
            love.graphics.print('FPS: '..love.timer.getFPS(), Camera.Pos.X + 10, -Camera.Pos.Y+10) -- render FPS
            love.graphics.print('Energy: '..Game.Player.Energy, Camera.Pos.X + 10, -Camera.Pos.Y+25) -- render FPS
        end
        --function Camera.Destroy(e) end
    
        return Camera
    end
}