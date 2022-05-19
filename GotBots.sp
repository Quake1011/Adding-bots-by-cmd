#include <sourcemod>
#include <cstrike>
#pragma tabsize 4
#define MaxBots 5
int i;
bool bAddBots;
public OnPluginStart()
{
    AddCommandListener(botAction, "sm_addbot");
    HookEvent("round_start",Ev_RS);
}

public OnMapStart()
{
    bAddBots = false;
}

public void OnClientConnected(int client)
{
	if(!IsFakeClient(client))
	{
		ServerCommand("bot_kick");
	}
}

public Action Ev_RS(Handle hEvent, const char[] name, bool bdb)
{
    for(int t = 1;t<MaxClients-1;t++)
    {
        if(IsFakeClient(t)&&!IsPlayerAlive(t))
        {
            CS_RespawnPlayer(t);
        }
    }
}

public Action botAction(client, const String:command[], argc)
{
    if (client && IsClientInGame(client) && !IsFakeClient(client))
    {
        if (!bAddBots)
        {
            if (GetClientCount_WithoutBots() == 1)
            {
				bAddBots = true;
                for (i = 0; i < MaxBots; i++)
                {
                    ServerCommand("bot_add");
                }
            }
        }
    }
}

public void OnClientDisconnect_Post(client)
{
    if (bAddBots)
    {
        if (GetClientCount_WithoutBots() < 1)
        {
            bAddBots = false;
            ServerCommand("bot_kick");
        }
    }
}


stock GetClientCount_WithoutBots()
{
    new iCounts;
    for(i = 1; i <= MaxClients; i++)
    {
        if (IsClientInGame(i) && !IsFakeClient(i) && !IsClientSourceTV(i))
        {
            iCounts++;
        }
    }
    return iCounts;
}