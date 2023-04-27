#include <cstrike>

#define BOTS 5

bool bAddBots;

public void OnPluginStart()
{
	RegAdminCmd("sm_addbot", botAction, ADMFLAG_ROOT);
    HookEvent("round_start",Ev_RS);
}

public void OnMapStart()
{
    bAddBots = false;
}

public void OnClientConnected(int client)
{
	if(!IsFakeClient(client))
		ServerCommand("bot_kick");
}

public Action Ev_RS(Event hEvent, const char[] name, bool bdb)
{
    for(int i = 1; i <= MaxClients; i++)
        if(IsFakeClient(i) && !IsPlayerAlive(i))
            CS_RespawnPlayer(i);
}

public Action botAction(int client, const char[] command, int argc)
{
    if(client && IsClientInGame(client) && !IsFakeClient(client))
    {
        if(!bAddBots && GetClientCount_WithoutBots() == 1)
        {
			bAddBots ^= true;
			for (i = 0; i < BOTS; i++)
				ServerCommand("bot_add");
        }
    }
}

public void OnClientDisconnect(int client)
{
    if(bAddBots && GetClientCount_WithoutBots() < 1)
    {
		bAddBots ^= true;
		ServerCommand("bot_kick");
    }
}


stock int GetClientCount_WithoutBots()
{
    int iCounts = 0;
    for(i = 1; i <= MaxClients; i++)
        if (IsClientInGame(i) && !IsFakeClient(i) && !IsClientSourceTV(i))
            iCounts++;
	    
    return iCounts;
}
