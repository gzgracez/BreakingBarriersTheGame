	/*
 Hello world!
*/

#include "eth_util.angelscript"

const uint white = ARGB(250,255,255,255);

int timeEnd;
int punchTime;
int countText = 0;
int jump_delay = 0;
int lastYPos;
int currentYPos = 0;
vector2 position;
int magnetInt = 1;
int timeCheck = 0;
bool flip = false;
bool jetpackOver = false;
int fuel = 100;
bool waterCheck = false;
int waterCof = 4;
int turrentFile = 1;

int timer = GetTime();
int timeWait = GetTime();
int openingWait = GetTime();
int timeDeath = GetTime();

bool waterproofing = false;
bool arms = false;
bool lazor = false;
bool magnet = false;
bool rockets = false;
bool unlock = false;
bool switchCheck = false;

int lastBrickPlace = 0;
int lastBackPlace = 0;

float moveSpeed = 4.0f;

bool delete = false;
bool delete2 = false;

int dist1;

void main()
{
	LoadScene("scenes\\opening.esc", "musix", "intro");

	// Prefer setting window properties in the app.enml file
	// SetWindowProperties("Ethanon Engine", 1024, 768, true, true, PF32BIT);
}

void musix(){
	LoadMusic("soundfx\\mus.mp3");
	PlaySample("soundfx\\mus.mp3");
	}

void intro(){
	if(GetTime() - openingWait > 2000 and GetTime() % 1000 >= 500){
		DrawText(vector2(300,400), "Press Enter to Start", "Verdana20.fnt", white);
		}
	}

void ETHCallback_logo(ETHEntity@ thisEntity){
	ETHInput@ input = GetInputHandle();
	thisEntity.SetPositionX(430);
	if(thisEntity.GetPositionY() > 200)thisEntity.AddToPositionY(-10);
	if(input.KeyDown(K_ENTER) and GetTime() - openingWait > 2000){
		LoadScene("scenes\\TEST.esc","onSceneLoad","onSceneLoop");
		}
	}

void onSceneLoad()
{
	SeekEntity(173).SetFlipY(true);
	for(int i = -1180; i <= 980; i +=40){
		for(int j = -460; j <= 300; j +=40){
			//print("bork");
			AddEntity("wall.ent",vector3(i,j,-1));
			}
		}
	ETHEntityArray walls;
	GetEntityArray("floor.ent", walls);
	for(int l = 0; l < walls.Size(); l++){
		AddEntity("point.ent",vector3(walls[l].GetPositionX(),walls[l].GetPositionY() - 20, 0));
		}
	ETHEntityArray waters;
	GetEntityArray("water.ent",waters);
	for(int k = 0; k < waters.Size();k++){
		waters[k].SetAlpha(0.5f);
		}
		
}

void onSceneLoop(){
	if(SeekEntity("robot.ent") is null and GetTime() - timeDeath > 200){
	AddEntity("robot.ent",vector3(1,-24,0));
	}
	if(lastBrickPlace < SeekEntity("robot.ent").GetPositionX() + 1){
		AddEntity("floor.ent",vector3(SeekEntity("robot.ent").GetPositionX() + 1, 20,0));
		lastBrickPlace = SeekEntity("robot.ent").GetPositionX() + 1;
		}
	if(lastBackPlace < SeekEntity("robot.ent").GetPositionX() + 300){
		AddEntity("back.ent",vector3(SeekEntity("robot.ent").GetPositionX() + 1940, -314,-1));
		lastBackPlace = SeekEntity("robot.ent").GetPositionX() + 1536;
		}
	//ETHEntityArray waters;
	//GetEntityArray("water.ent",waters);
	//for(int k = 0; k < waters.Size();k++){
	//	waters[k].SetAlpha(0.5f);
	//	}
	//DrawFadingText(GetCameraPos(), "the lazy grey fox", "Verdana20.fnt", white, 2000);
	//DrawText(vector2 (SeekEntity("robot.ent").GetPositionX() / 10, 10 + SeekEntity("robot.ent").GetPositionY() / 10), "the lazy grey fox", "Verdana20.fnt", white);
	//print("cameraPos" + GetCameraPos());
	//print("robotpos" + SeekEntity("robot.ent").GetPositionX() + SeekEntity("robot.ent").GetPositionY());
}	

void ETHCallback_robot(ETHEntity@ robot){
ETHInput@ input = GetInputHandle();
ETHPhysicsController@ controller = robot.GetPhysicsController();

//SetGravity(vector2(0, magnetInt *25 * waterCof));

if(GetTime() - timeDeath >= 500 and robot.IsHidden() == true)robot.Hide(false);

position = robot.GetPositionXY();
if(robot.IsHidden() == false){
SetCameraPos(vector2(position.x - 400,position.y - 300));
}

waterCheck = isInWater();
if(waterCheck == true and waterproofing == true)
{
	waterCof = 1;
}
else{waterCof = 4;}

if (waterCheck)
	{SetGravity(vector2(0, 0.7));}
else
	{SetGravity(vector2(0, 9.7));}
	
SetGravity(vector2(0, GetGravity().y * magnetInt));
//move robot
controller.SetFriction(0);
if(SeekEntity("barrier.ent") != null){
dist1 = distance(robot.GetPositionXY(), SeekEntity("barrier.ent").GetPositionXY());
}
if (input.KeyDown(K_DOWN) and dist1 > 50 and dist1 < 100){
	delete = true;
	print("test");
	punchTime = GetTime();
	}
	
if (input.KeyDown(K_UP) and dist1 > 50 and dist1 < 100){
	delete2 = true;
	print("test");
	punchTime = GetTime();
	}


//robotMovementVector(robot, controller.GetLinearVelocity().y);
//DrawText(robot.GetPositionXY(), "dx " + robot.GetInt("dx") + " dy " + robot.GetInt("dy"), "Verdana20.fnt", white);
//DrawText(vector2(robot.GetPositionXY().x, robot.GetPositionXY().y + 20), "lxy " + controller.GetLinearVelocity().x + controller.GetLinearVelocity().y, "Verdana20.fnt", white);
if (controller.GetLinearVelocity().x != robot.GetInt("dx")){
	controller.SetLinearVelocity(vector2(robot.GetInt("dx"), controller.GetLinearVelocity().y));
}
if (0 > robot.GetInt("dy")){
	controller.SetLinearVelocity(vector2(controller.GetLinearVelocity().x, robot.GetInt("dy")));
}
	
if(robot.GetInt("dy") <= 0){robot.AddToInt("dy", 2);}
//print(robot.GetInt("dy"));
lastYPos = currentYPos;
currentYPos = robot.GetPositionY();

robotDrawSprite(robot);
robot.AddToPositionX(moveSpeed);

}

void robotDrawSprite(ETHEntity@ robot){
	int numframes = 1;
	string whichsprite = "";
	string standOrWalking = "";
	
	//which sprite to use
	if (rockets)
		whichsprite = "rocket";
	else if (magnet)
		whichsprite = "magnet";
	else if (arms)
		whichsprite = "arms";
	else if (lazor)
		whichsprite = "lazor";
	else if (waterproofing)
		whichsprite = "shiny";
	else 
		whichsprite = "legs";
	
	//standing or walking, which direction
	if (robot.GetInt("dx") > 0){
		robot.SetFlipX(false);
		//standOrWalking = "walking";
		numframes = 4;
	}
	else if (robot.GetInt("dx") < 0){
		robot.SetFlipX(true);
		//standOrWalking = "walking";
		numframes = 4;
	}
	else {
		//standOrWalking = "standing";
		numframes = 2;
	}
	//print(robot.GetInt("dx"));
	standOrWalking = "walking";
	if(GetTime() - punchTime < 200){
		robot.SetSprite("robot_punch.png");
		}
	else{
		string path = "entities\\sprites" + "\\robot_" + "treads" + "_" + "standing" + "_" + (1 + (GetTime() / 85) % numframes) + ".png";
		robot.SetSprite(path);
		}
	//print ("path:");
	//print ("entities\\sprites" + "\\robot_" + whichsprite + "_" + standOrWalking + "_" + (1 + (GetTime() / 85) % (numframes + 1)) + ".png");
}

void robotMovementVector(ETHEntity@ thisEntity, int linearAccelY)
{	
	thisEntity.SetInt("dx", 0);
	int character_speed = 5;
	int jump_speed = -7	 * waterCof;
	bool use = false;
	
	vector2 normal, point;
	vector2 testPoint(position.x, -10000);
	ETHEntity@ temp = GetClosestContact(position,testPoint,point,normal);
	
	jump_delay = jump_delay - 1;
	
	ETHInput@ input = GetInputHandle();
	
	if(currentYPos == lastYPos)thisEntity.AddToPositionY(-0.003f);
	
	if(position.x > 1000) Exit();

	if (input.KeyDown(K_W) and thisEntity.IsHidden() == false)
		if ((/*currentYPos == lastYPos abs(linearAccelY) <= 0.02*/(isNearFloor(thisEntity, 40) or isNearBox(thisEntity,100)) and magnetInt == 1 and jump_delay <= 0) or waterCheck == true){
			thisEntity.SetInt("dy", jump_speed);
			jump_delay = 20;
			}
	//if (input.KeyDown(K_S))
		//
	if (input.KeyDown(K_D) and thisEntity.IsHidden() == false){
		thisEntity.SetInt("dx", character_speed);
		}
	if (input.KeyDown(K_A) and thisEntity.IsHidden() == false){
		thisEntity.SetInt("dx", -(character_speed));
		}
	if(input.KeyDown(K_X) and thisEntity.IsHidden() == false){
		if(temp !is null and distance(position,temp.GetPositionXY()) < 300 and GetTime() - timeCheck > 1000 and magnet == true){
				magnetInt = magnetInt * -1;
				thisEntity.SetFlipY(!flip);
				flip = !flip;
				timeCheck = GetTime();
			}
		}
	if(input.KeyDown(K_SPACE) and fuel > 0 and jetpackOver == false and rockets == true and thisEntity.IsHidden() == false){
		thisEntity.SetInt("dy",-15);
		use = true;
		fuel-= 2;
		if(fuel <= 0) jetpackOver = true;
		}
	if(input.KeyDown(K_Z) and GetTime() - timeWait >= 400 and lazor == true and thisEntity.IsHidden() == false){
		timeWait = GetTime();
		LoadSoundEffect("soundfx\\lazer.wav");
		PlaySample("soundfx\\lazer.wav");
		int id = AddEntity("robot_bullet.ent",vector3(position.x, position.y - 25, 0));
		if(thisEntity.GetFlipX() == true) SeekEntity(id).SetFloat("direct",-1.0f);
		else{SeekEntity(id).SetFloat("direct",1.0f);}
		}
	if(temp is null){
		magnetInt = 1;
		flip = false;
		thisEntity.SetFlipY(flip);
		}
	if(use == false and fuel < 100)fuel++;
	if(fuel >= 100) jetpackOver = false;
}

/*void ETHCallback_tile(ETHEntity@ tile){
ETHInput@ input = GetInputHandle();
ETHPhysicsController@ controller = tile.GetPhysicsController();

	if (input.KeyDown(K_P))
		controller.SetLinearVelocity(vector2(0,2));

}*/
bool isNearFloor(ETHEntity@ thisEntity, float dist){
ETHEntityArray floorTiles;
GetEntityArray("point.ent",floorTiles);
for(uint i =0; i < floorTiles.Size();i++){
	if(distance(thisEntity.GetPositionXY(),floorTiles[i].GetPositionXY()) <= dist){
		//print("ITS TRUE");
		return true;
		}
	}
	return false;
}

bool isNearBox(ETHEntity@ thisEntity, float dist){
ETHEntityArray floorTiles;
GetEntityArray("crate_1.ent",floorTiles);
GetEntityArray("crate_2.ent",floorTiles);
GetEntityArray("crate_3.ent",floorTiles);
for(uint i =0; i < floorTiles.Size();i++){
	if(distance(thisEntity.GetPositionXY(),floorTiles[i].GetPositionXY()) <= dist){
		//print("ITS TRUE");
		return true;
		}
	}
	return false;
}

bool isInWater(){
ETHEntityArray waterTiles;
GetEntityArray("water.ent",waterTiles);
for(uint i =0; i < waterTiles.Size();i++){
	if(distance(position,waterTiles[i].GetPositionXY()) <= 50){
		//print("ITS TRUE");
		return true;
		}
	}
	return false;
	}
	
void ETHCallback_wire_1(ETHEntity@ thisEntity){
	if(distance(position,thisEntity.GetPositionXY()) <= 30){
		DeleteEntity(SeekEntity("robot.ent"));
		LoadSoundEffect("soundfx\\death.wav");
		PlaySample("soundfx\\death.wav");
		int id = AddEntity("robot.ent",vector3(1,-24,0));
		SeekEntity(id).Hide(true);
		timeDeath = GetTime();
		}
	thisEntity.SetSprite("wire_" + (1 + (GetTime() / 100) % 4) + ".png");
}

void ETHCallback_water(ETHEntity@ thisEntity){
	if(distance(position,thisEntity.GetPositionXY()) <= 50 and waterproofing == false){
		DeleteEntity(SeekEntity("robot.ent"));
		LoadSoundEffect("soundfx\\death.wav");
		PlaySample("soundfx\\death.wav");
		timeDeath = GetTime();
		int id = AddEntity("robot.ent",vector3(1,-24,0));
		SeekEntity(id).Hide(true);
		timeDeath = GetTime();
		}
	thisEntity.SetSprite("water_" + (1 + (GetTime() / 145) % 4) + ".png");
	thisEntity.SetAlpha(0.5f);
}

void ETHCallback_waterproof(ETHEntity@ thisEntity){
	if(distance(position,thisEntity.GetPositionXY()) <=20){
	LoadSoundEffect("soundfx\\collect.wav");
	PlaySample("soundfx\\collect.wav");
		waterproofing = true;
		DeleteEntity(thisEntity);
		}
	}
	
void ETHCallback_bigarms(ETHEntity@ thisEntity){
	if(distance(position,thisEntity.GetPositionXY()) <=20){
		arms = true;
		LoadSoundEffect("soundfx\\collect.wav");
		PlaySample("soundfx\\collect.wav");
		vector2 tempPos = SeekEntity("meteor.ent").GetPositionXY();
		DeleteEntity(SeekEntity("meteor.ent"));
		AddEntity("meteorD.ent",vector3(tempPos,0));
		DeleteEntity(thisEntity);
		}
	}

void ETHCallback_laser(ETHEntity@ thisEntity){
	if(distance(position,thisEntity.GetPositionXY()) <=20){
		lazor = true;
		LoadSoundEffect("soundfx\\collect.wav");
		PlaySample("soundfx\\collect.wav");
		DeleteEntity(thisEntity);
		}
	}
	
void ETHCallback_accessCard(ETHEntity@ thisEntity){
	if(distance(position,thisEntity.GetPositionXY()) <=20){
		unlock = true;
		LoadSoundEffect("soundfx\\collect.wav");
		PlaySample("soundfx\\collect.wav");
		DeleteEntity(thisEntity);
		}
	}
	
void ETHCallback_magnetArms(ETHEntity@ thisEntity){
	if(distance(position,thisEntity.GetPositionXY()) <=20){
		magnet = true;
		LoadSoundEffect("soundfx\\collect.wav");
		PlaySample("soundfx\\collect.wav");
		DeleteEntity(thisEntity);
		}
	}
	
void ETHCallback_Jetpack(ETHEntity@ thisEntity){
	if(distance(position,thisEntity.GetPositionXY()) <=20){
		rockets = true;
		LoadSoundEffect("soundfx\\collect.wav");
		PlaySample("soundfx\\collect.wav");
		DeleteEntity(thisEntity);
		}
	}

void ETHCallback_door_1(ETHEntity@ thisEntity){
	if(distance(position,thisEntity.GetPositionXY()) <=65 and unlock == true){
	LoadSoundEffect("soundfx\\door.wav");
	PlaySample("soundfx\\door.wav");
			if ((GetTime() - timer) >= 200 and thisEntity.GetInt("door_state") < 4){
				timer = GetTime();
				thisEntity.AddToInt("door_state", 1);
				thisEntity.SetSprite("door_" + thisEntity.GetInt("door_state") + ".png");
			}
			else if (thisEntity.GetInt("door_state") >= 4)
				DeleteEntity(thisEntity);

	}
	else if (thisEntity.GetInt("door_state") > 1 and (GetTime() - timer) >= 200){
		timer = GetTime();
		thisEntity.AddToInt("door_state", -1);
		thisEntity.SetSprite("door_" + thisEntity.GetInt("door_state") + ".png");
	}
}

void ETHCallback_barrier(ETHEntity@ thisEntity){
	if(delete == true and thisEntity.GetPositionY() == -20){
		delete = false;
		delete2 = false;
		int tX = thisEntity.GetPositionX();
		DetermineBarrier(tX);
		//AddEntity("barrier.ent", vector3(tX + 300 + rand(100), -60, 0));
		DeleteEntity(thisEntity);
		}
	else if(delete2 == true and thisEntity.GetPositionY() == -60){
		delete = false;
		delete2 = false;
		int tX = thisEntity.GetPositionX();
		DetermineBarrier(tX);
		//AddEntity("barrier.ent", vector3(tX + 300 + rand(100), -60, 0));
		DeleteEntity(thisEntity);
		}
	else if(distance(thisEntity.GetPositionXY(),SeekEntity("robot.ent").GetPositionXY()) < 50){
		openingWait = GetTime();
		moveSpeed = 4.0f;
		countText = 0;
		LoadScene("scenes\\GameOver.esc", "start1", "end");
	}
}

void start1(){
	timeEnd = GetTime();
	}

void end(){
	ETHInput@ input = GetInputHandle();
	if(input.KeyDown(K_UP) and GetTime() - openingWait > 1000){
		LoadScene("scenes\\TEST.esc","onSceneLoad","onSceneLoop");
		}
	}


void DetermineBarrier(int x){
	countText++;
	moveSpeed += 0.3f;
	int temp = (rand(1)) * -40;
	int id;
	int id2;
	id2 = AddEntity("barrier.ent", vector3(x + 300 + rand(100), -20 + temp, 0));
	if(temp == -40){
		//SeekEntity(id2).SetSprite("crate_4.png");
		}
	if(countText >= 24) countText = 0;
	if(countText == 1){
		id = AddEntity("text.ent",vector3(SeekEntity("robot.ent").GetPositionX() + 200,80,0));
		SeekEntity(id).SetSprite("knowledge_1.png");
		SeekEntity(id2).SetSprite("knowledge barrier.png");
		}
	if(countText == 5){
		id = AddEntity("text.ent",vector3(SeekEntity("robot.ent").GetPositionX() + 200,80,0));
		SeekEntity(id).SetSprite("language_1.png");
		SeekEntity(id2).SetSprite("language barrier.png");
		}
	if(countText == 9){
		id = AddEntity("text.ent",vector3(SeekEntity("robot.ent").GetPositionX() + 200,80,0));
		SeekEntity(id).SetSprite("technology_1.png");
		SeekEntity(id2).SetSprite("technology barrier.png");
		}
	if(countText == 13){
		id = AddEntity("text.ent",vector3(SeekEntity("robot.ent").GetPositionX() + 200,80,0));
		SeekEntity(id).SetSprite("communication_1.png");
		SeekEntity(id2).SetSprite("communication barrier.png");
		}
	if(countText == 17){
		id = AddEntity("text.ent",vector3(SeekEntity("robot.ent").GetPositionX() + 200,80,0));
		SeekEntity(id).SetSprite("physical_1.png");
		SeekEntity(id2).SetSprite("physical barrier.png");
		}
	if(countText == 21){
		id = AddEntity("text.ent",vector3(SeekEntity("robot.ent").GetPositionX() + 200,80,0));
		SeekEntity(id).SetSprite("social_1.png");
		SeekEntity(id2).SetSprite("social barrier 2.png");
		}
		
}
	
void ETHCallback_enemy(ETHEntity@ thisEntity){
	if(thisEntity.GetPositionX() > -250) {thisEntity.SetInt("dir",-1);}
	if(thisEntity.GetPositionX() < -490){ thisEntity.SetInt("dir",1);}
	thisEntity.SetSprite("enemy_melee_" + (1 + (GetTime() / 145) % 3) + ".png");
	thisEntity.AddToPositionX(3 * thisEntity.GetInt("dir"));
	if(distance(position,thisEntity.GetPositionXY()) <= 30){
		DeleteEntity(SeekEntity("robot.ent"));
			LoadSoundEffect("soundfx\\death.wav");
		PlaySample("soundfx\\death.wav");
		int id = AddEntity("robot.ent",vector3(1,-24,0));
		SeekEntity(id).Hide(true);
		timeDeath = GetTime();
		}
	}
	
	
	

void ETHCallback_turrent(ETHEntity@ thisEntity){
	if(GetTime() % 20 == 0 and switchCheck == false){
		AddEntity("enemy_bullet.ent",vector3(thisEntity.GetPositionX() + 10, thisEntity.GetPositionY(),0));
		if(turrentFile == 1){
			thisEntity.SetSprite("turret_2.png");
			turrentFile = 2;
			}
		else if(turrentFile == 2){
			thisEntity.SetSprite("turret_1.png");
			turrentFile = 1;
			}
		}
}

void ETHCallback_enemy_bullet(ETHEntity@ thisEntity){
	thisEntity.AddToPositionX(4.0f);
	ETHEntityArray stuff;
	GetEntityArray("robot.ent", stuff);
	GetEntityArray("crate_1.ent",stuff);
	GetEntityArray("crate_2.ent",stuff);
	GetEntityArray("crate_3.ent",stuff);
	GetEntityArray("floor.ent",stuff);
	for(int i = 0; i < stuff.Size() -1; i++){
		if(distance(thisEntity.GetPositionXY(),stuff[i].GetPositionXY()) <= 50){
			if(stuff[i].GetEntityName() == "robot.ent") {DeleteEntity(stuff[i]);
			int id = AddEntity("robot.ent",vector3(1,-24,0));
			SeekEntity(id).Hide(true);
			timeDeath = GetTime();
			}
			DeleteEntity(thisEntity);
			}
		}
}

void ETHCallback_robot_bullet(ETHEntity@ thisEntity){
	//float i = 1.0f;
	//if(SeekEntity("robot.ent").GetFlipX() == true) i = -1.0f;
	//controller = thisEntity.
	thisEntity.AddToPositionX(8.0f * thisEntity.GetFloat("direct"));
	ETHEntityArray stuff;
	GetEntityArray("turrent.ent", stuff);
	GetEntityArray("enemy.ent", stuff);
	GetEntityArray("door_1.ent", stuff);
	GetEntityArray("crate_1.ent",stuff);
	GetEntityArray("crate_2.ent",stuff);
	GetEntityArray("crate_3.ent",stuff);
	GetEntityArray("floor.ent",stuff);
	for(int i = 0; i < stuff.Size() -1; i++){
		if(distance(thisEntity.GetPositionXY(),stuff[i].GetPositionXY()) <= 50){
			if(stuff[i].GetEntityName() == "enemy.ent") {DeleteEntity(stuff[i]);
			}
			DeleteEntity(thisEntity);
			}
		}
}

void ETHCallback_lever(ETHEntity@ thisEntity){
	ETHInput@ input = GetInputHandle();
	if(input.KeyDown(K_E) and distance(thisEntity.GetPositionXY(),position) <= 20){
		thisEntity.SetSprite("lever_on.png");
		LoadSoundEffect("soundfx\\turrent.wav");
		PlaySample("soundfx\\turrent.wav");
		switchCheck = true;
		DeleteEntity(SeekEntity("turrent.ent"));
		AddEntity("turrent.ent",vector3(-860,-20,0));
		SeekEntity("turrent.ent").AddToAngle(90);
		for(int i = -1140; i < -500; i+= 40){
			for(int j = -180; j <= -20; j+= 40){
				int id = AddEntity("water.ent", vector3(i,j,0));
					print(SeekEntity(id).GetAlpha());
			}
		}
	AddEntity("water.ent", vector3(-820,-220,0));
	AddEntity("water.ent", vector3(-780,-220,0));
	AddEntity("water.ent", vector3(-740,-220,0));
	}
}