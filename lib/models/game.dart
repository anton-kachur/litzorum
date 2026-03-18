import 'package:hive/hive.dart';

part 'game.g.dart';

@HiveType(typeId: 1)
class Game extends HiveObject {

  // Main game settings --------------------------------------------------------

  @HiveField(0)
  late String gameId;

  @HiveField(1)
  late String gameStartDate;

  @HiveField(2)
  late String playerName;

  @HiveField(3)
  late double reigningYears;

  // Government ----------------------------------------------------------------

  @HiveField(4)
  late String ideology;

  @HiveField(5)
  late double leadersPopularity;

  @HiveField(6)
  late int population;

  @HiveField(7)
  late double budget;

  @HiveField(8)
  late double goods;

  @HiveField(9)
  late String exchangeRate;

  // People --------------------------------------------------------------------

  @HiveField(10)
  late double educationLevel;

  @HiveField(11)
  late double purchasingPower;

  @HiveField(12)
  late double lifeQuality;

  // Industry ------------------------------------------------------------------

  @HiveField(13)
  late int heavyIndustryFactoriesNumber;

  @HiveField(14)
  late double heavyIndustryGoodsOutput;

  @HiveField(15)
  late int lightIndustryFactoriesNumber;
  
  @HiveField(16)
  late double lightIndustryGoodsOutput;

  @HiveField(17)
  late int agricultureFarmsNumber;

  @HiveField(18)
  late double agricultureFarmsGoodsOutput;

  // Science -------------------------------------------------------------------

  @HiveField(19)
  late int schoolsNumber;
  
  @HiveField(20)
  late int universitiesNumber;

  @HiveField(21)
  late int researchCentersNumber;

  @HiveField(22)
  late List<String> bigProjects;
  
  // Army ----------------------------------------------------------------------

  @HiveField(23)
  late double HQLevel;

  @HiveField(24)
  late double attackLevel;

  @HiveField(25)
  late double defenceLevel;

  // Culture -------------------------------------------------------------------

  @HiveField(26)
  late double cultureLevel;

  @HiveField(27)
  late double highCultureLevel;

  @HiveField(28)
  late double massCultureLevel;


  Game({
    required this.gameId, required this.gameStartDate, required this.playerName, 
    required this.reigningYears, required this.ideology, 
    required this.leadersPopularity, required this.population, 
    required this.budget, required this.goods, required this.exchangeRate, 
    required this.educationLevel, required this.purchasingPower, 
    required this.lifeQuality, required this.heavyIndustryFactoriesNumber, 
    required this.heavyIndustryGoodsOutput, 
    required this.lightIndustryFactoriesNumber, 
    required this.lightIndustryGoodsOutput, 
    required this.agricultureFarmsNumber, 
    required this.agricultureFarmsGoodsOutput, required this.schoolsNumber, 
    required this.universitiesNumber, required this.researchCentersNumber, 
    required this.bigProjects, required this.HQLevel, required this.attackLevel, 
    required this.defenceLevel, required this.cultureLevel, 
    required this.highCultureLevel, required this.massCultureLevel
  });

  get values => null;

  @override
  String toString() {
    return "\ngame id: $gameId" + 
    "\nplayer name: $playerName\n\nyears of reign: ${double.parse(reigningYears.toStringAsFixed(1))}\n" +
    "ideology: $ideology\npopularity: ${double.parse(leadersPopularity.toStringAsFixed(1))}%" +
    "\n\npopulation: ${double.parse((population / 1000000).toStringAsFixed(1))}M" +
    "\nbudget: $budget\ngoods produced: $goods\n\n" + 
    "education level: ${double.parse(educationLevel.toStringAsFixed(3))}\n" +
    "purchasing power: ${double.parse(purchasingPower.toStringAsFixed(3))}""\n" + 
    "life quality: ${double.parse(lifeQuality.toStringAsFixed(3))}\n\n" +
    "heavy industry built: $heavyIndustryFactoriesNumber\n" +
    "light industry built: $lightIndustryFactoriesNumber\n" +
    "farms built: $agricultureFarmsNumber" +
    "\n\nschools built: $schoolsNumber\nuniversities built: $universitiesNumber" "\n" +
    "research centers built: $researchCentersNumber\nbig projects led: ${bigProjects.length}\n\n" +
    "HQ level: $HQLevel\nattack power: $attackLevel\ndefence power: $defenceLevel" + 
    "\n\nculture level: ${double.parse(cultureLevel.toStringAsFixed(1))}\n" +
    "high culture: ${double.parse(highCultureLevel.toStringAsFixed(1))}\n" +
    "mass culture: ${double.parse(massCultureLevel.toStringAsFixed(1))}";    
  }
}