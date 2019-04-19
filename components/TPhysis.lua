TComponent = require 'components/TComponent'

function checkCollision(obj1, obj2, side)
    local P1 = {
        X = math.max(obj1.Pos.X-obj1.Origins.X, obj2.Pos.X-obj2.Origins.X),
        Y = math.max(obj1.Pos.Y-obj1.Origins.Y, obj2.Pos.Y-obj2.Origins.Y)
    }
    local P2 = {
        X = math.min(obj1.Pos.X-obj1.Origins.X+obj1.Size.Width, obj2.Pos.X-obj2.Origins.X+obj2.Size.Width),
        Y = math.min(obj1.Pos.Y-obj1.Origins.Y+obj1.Size.Height, obj2.Pos.Y-obj2.Origins.Y+obj2.Size.Height)
    }
    local sideBySide = true 
    --sudeBySide conisdera maior ou igual
    return (P2.X-P1.X >= 0 and P2.Y-P1.Y >= 0)
end


return {
    New = function(_id)
        local physis = TComponent.New 'Physis'
        physis.components = {}

        function physis.Init(e, args) Game.Physis = physis end    
        function physis.Append(e, args) 
            local obj = e.New(args)
            obj.Init()
            obj.Size.Height = obj.Image:getHeight()
            obj.Size.Width  = obj.Image:getWidth()
            obj.Origins.X = obj.Size.Width/2
            obj.Origins.Y = obj.Size.Height/2   
            table.insert(physis.components, obj) 
        end   
        function physis.Remove(e) table.remove(physis.components, e) end
        function physis.Update(dt) 
            for i, obj in pairs(physis.components) do 
                obj.Update(dt) 
                if obj._remove == true then return table.remove(physis.components, i) end
                for j, obj2 in pairs(physis.components) do
                    if i ~= j and checkCollision(obj, obj2) --[[ and obj.ID ~= obj2.ID ]] then
                        obj.Collides(obj2)
                        obj2.Collides(obj)
                    end
                end
            end 
        end
        function physis.Render() for i, obj in pairs(physis.components) do obj.Render() end end
        function physis.getObject(_id) 
            for i, obj in pairs(physis.components) do 
                if obj.ID == _id then 
                    return obj 
                end 
            end
        end
        --function physis.Destroy(e) end
    
        return physis
    end
}