import 'dart:math';

class GameData {
  static final List<String> challenges = [
    "Fais-moi deviner ton prénom sans le dire 🤔",
    "Tiens mon regard 5 secondes sans rire 👀",
    "Chuchote ton crush du moment à l'oreille 😏",
    "Chante une ligne d'une chanson que t'aimes 🎵",
    "Raconte-moi ton rêve le plus fou en 30s ✨",
    "Imite mon expression préférée 😎",
    "Dis-moi un compliment original 💫",
    "Fais-moi deviner ton plat favori sans le nommer 🍕",
    "Montre-moi ta danse signature (3sec) 💃",
    "Raconte une blague qui me fera sourire 😄",
    "Mime ton film préféré en 10 secondes 🎬",
    "Chuchote un secret innocent à l'oreille 🤫",
    "Fais-moi deviner ton âge sans le dire 🎂",
    "Montre-moi ton talent caché 🌟",
    "Raconte ton moment le plus gênant 🙈"
  ];

  static final List<String> penalties = [
    "Tu dois dire une vérité gênante 😳",
    "Tu m'offres un sourire 100% sincère maintenant 😊",
    "Tu m'invites à boire un verre 🍹",
    "Tu likes ma dernière photo Insta 😎",
    "Tu danses 3 sec avec moi là tout de suite 💃",
    "Tu me donnes ton numéro... de chance préféré 📱",
    "Tu me fais un câlin de 3 secondes 🤗",
    "Tu me chuchotes un secret à l'oreille 🤫",
    "Tu dois m'apprendre un mot dans une autre langue 🌍",
    "Tu me racontes ton moment le plus embarrassant 🙈",
    "Tu me fais ton plus beau sourire 😄",
    "Tu m'imites pendant 10 secondes 🎭",
    "Tu me dis ton plus gros défaut 😅",
    "Tu me montres ta photo la plus drôle 📸",
    "Tu me racontes ton pire rencard 💔"
  ];

  static final List<String> successMessages = [
    "Trop forte ! Tu gagnes le droit de me poser une question (n'importe laquelle 👀)",
    "Incroyable ! À ton tour de me challenger maintenant 🔥",
    "Parfait ! Tu mérites une récompense... pose-moi ta question 💎",
    "Bravo ! Je suis impressionné, tu gagnes un free pass question 🎯",
    "Excellent ! Tu peux maintenant me demander ce que tu veux 🌟",
    "Magnifique ! Tu as mérité une question bonus 🎁",
    "Chapeau ! À toi de prendre les commandes maintenant 👑",
    "Impressionnant ! Tu débloques le droit de curiosité 🔓"
  ];

  static final Random _random = Random();

  static String getRandomChallenge() {
    return challenges[_random.nextInt(challenges.length)];
  }

  static String getRandomPenalty() {
    return penalties[_random.nextInt(penalties.length)];
  }

  static String getRandomSuccessMessage() {
    return successMessages[_random.nextInt(successMessages.length)];
  }

  static int get challengesCount => challenges.length;
  static int get penaltiesCount => penalties.length;

  static getChallenges() {
    return List<String>.from(challenges);
  }
}