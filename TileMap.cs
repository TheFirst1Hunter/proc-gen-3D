using Godot;
using System;

public class TileMap : Godot.TileMap
{
    enum Tiles
    {
        WALL = -1,
        ICON = 0
    }
    private int[,] grid = new int[20, 20];
    public override void _Ready()
    {
        GD.Randomize();
        for (int i = 0; i < 20; i++)
        {
            for (int j = 0; j < 20; j++)
            {
                if (i == 0 || j == 0 || i == 19 || j == 19)
                    grid[i, j] = (int)Tiles.WALL;
                else
                    grid[i, j] = Math.Abs((int)GD.Randi() % 4);
            }
        }

        for (int i = 0; i < 20; i++)
        {
            for (int j = 0; j < 20; j++)
            {
                if (grid[i, j] == (int)Tiles.WALL)
                    SetCell(i, j, 1);
                else
                    if (grid[i, j] == (int)Tiles.ICON)
                    SetCell(i, j, (int)((i + j) * GD.Randi()) % 2);

            }
        }
    }

    void _on_Timer_timeout()
    {
        GD.Print("t");
    }
}
