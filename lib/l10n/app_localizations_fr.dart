// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'EduManage';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get add => 'Ajouter';

  @override
  String get search => 'Rechercher';

  @override
  String get confirm => 'Confirmer';

  @override
  String get close => 'Fermer';

  @override
  String get back => 'Retour';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get loading => 'Chargement...';

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String get errorOccurred => 'Une erreur est survenue';

  @override
  String get operationSuccessful => 'Opération réussie';

  @override
  String get confirmDelete => 'Êtes-vous sûr de vouloir supprimer ?';

  @override
  String get fieldRequired => 'Ce champ est obligatoire';

  @override
  String get login => 'Connexion';
  @override
  String get username => 'Nom d\'utilisateur';
  @override
  String get password => 'Mot de passe';
  @override
  String get invalidCredentials => 'Nom d\'utilisateur ou mot de passe incorrect';
  @override
  String get users => 'Utilisateurs';
  @override
  String get role => 'Rôle';
  @override
  String get firstName => 'Prénom';
  @override
  String get lastName => 'Nom';
  @override
  String get active => 'Actif';
  @override
  String get inactive => 'Inactif';
  @override
  String get admin => 'Administrateur';
  @override
  String get teacher => 'Enseignant';
  @override
  String get addUser => 'Ajouter un utilisateur';
  @override
  String get editUser => 'Modifier l\'utilisateur';
  @override
  String get settings => 'Paramètres';
  @override
  String get language => 'Langue';
  @override
  String get arabic => 'Arabe';
  @override
  String get francais => 'Français';
  @override
  String get sessionTimeout => 'Délai d\'expiration';
  @override
  String get about => 'À propos';
  @override
  String get version => 'Version';
  @override
  String get minutes => 'minutes';
  @override
  String get dashboard => 'Tableau de bord';
  @override
  String get totalStudents => 'Total Étudiants';
  @override
  String get totalTeachers => 'Total Enseignants';
  @override
  String get todaySessions => 'Séances du jour';
  @override
  String get todayAttendance => 'Présences du jour';
  @override
  String get monthlyRevenue => 'Revenu Mensuel';
  @override
  String get outstandingDebts => 'Dettes Impayées';
  @override
  String get quickActions => 'Actions Rapides';
  @override
  String get scanBarcode => 'Scanner le code-barres';
  @override
  String get checkIn => 'Pointage';
  @override
  String get checkInSuccess => 'Pointage réussi';
  @override
  String get checkInFailed => 'Échec du pointage';
  @override
  String get studentNotFound => 'Élève introuvable';
  @override
  String get noActiveSession => 'Aucune séance active';
  @override
  String get multipleSessionsFound => 'Plusieurs séances trouvées';
  @override
  String get selectSession => 'Sélectionner une séance';
  @override
  String get alreadyCheckedIn => 'Déjà pointé';
  @override
  String get searchStudent => 'Rechercher un élève';
  @override
  String get teacherCheckin => 'Pointage enseignant';
  @override
  String get scanTeacherBarcode => 'Scanner le code-barres enseignant';
  @override
  String get teacherNotFound => 'Enseignant introuvable';
  @override
  String get teacherCheckinSuccess => 'Pointage enseignant réussi';
  @override
  String get teacherAlreadyCheckedIn => 'Enseignant déjà pointé aujourd\'hui';
  @override
  String get noActiveSessionForTeacher => 'Aucune séance active pour cet enseignant';
  @override
  String get name => 'Nom';
  @override
  String get floor => 'Étage';
  @override
  String get capacity => 'Capacité';
  @override
  String get note => 'Note';
  @override
  String get status => 'Statut';
  @override
  String get all => 'Tout';
  @override
  String get classrooms => 'Salles de classe';
  @override
  String get enrollStudent => 'Inscrire un élève';
  @override
  String get students => 'Élèves';
  @override
  String get groups => 'Groupes';
  @override
  String get customPrice => 'Prix personnalisé';
  @override
  String get discount => 'Remise';
  @override
  String get enrollments => 'Inscriptions';
  @override
  String get noEnrollments => 'Aucune inscription';
  @override
  String get dropEnrollment => 'Annuler l\'inscription';
  @override
  String get subject => 'Matière';
  @override
  String get schoolLevel => 'Niveau scolaire';
  @override
  String get description => 'Description';
  @override
  String get amountMustBePositive => 'Le montant doit être positif';
  @override
  String get saveSuccess => 'Enregistrement réussi';
  @override
  String get financialStatus => 'Situation financière';
  @override
  String get income => 'Revenus';
  @override
  String get payments => 'Paiements';
  @override
  String get expenses => 'Dépenses';
  @override
  String get teacherPayouts => 'Paiements enseignants';
  @override
  String get amount => 'Montant';
  @override
  String get category => 'Catégorie';
  @override
  String get rent => 'Loyer';
  @override
  String get salary => 'Salaire';
  @override
  String get materials => 'Fournitures';
  @override
  String get utilities => 'Factures';
  @override
  String get other => 'Autre';
  @override
  String get expense => 'Dépense';
  @override
  String get paymentHistory => 'Historique des paiements';
  @override
  String get teachers => 'Enseignants';
  @override
  String get code => 'Code';
  @override
  String get phone => 'Téléphone';
  @override
  String get address => 'Adresse';
  @override
  String get email => 'Email';
  @override
  String get idCard => 'Carte d\'identité';
  @override
  String get salaryType => 'Type de salaire';
  @override
  String get percentage => 'Pourcentage';
  @override
  String get fixed => 'Fixe';
  @override
  String get teacherShare => 'Part enseignant %';
  @override
  String get teacherFixedAmount => 'Montant fixe enseignant';
  @override
  String get employmentStartDate => 'Date de début d\'emploi';
  @override
  String get sessionCancellation => 'Annulation de séance';
  @override
  String get selectDate => 'Sélectionner une date';
  @override
  String get reason => 'Raison';
  @override
  String get cancellationCreated => 'Annulation créée';
  @override
  String get reactivate => 'Réactiver';
  @override
  String get upcomingCancellations => 'Annulations à venir';
  @override
  String get noActiveSessions => 'Aucune séance active';
  @override
  String get cancelConfirmation => 'Êtes-vous sûr de vouloir annuler cette séance ?';
  @override
  String get session => 'Séance';
  @override
  String get cancelledOn => 'Annulée le';
  @override
  String get checkedIn => 'Pointé';
  @override
  String get missing => 'Absent';
  @override
  String get expected => 'Attendu';
  @override
  String get noAttendanceToday => 'Aucun enregistrement de présence aujourd\'hui';
  @override
  String get attendanceTime => 'Heure';
  @override
  String get presentCount => 'Présents';
  @override
  String get absentCount => 'Absents';
  @override
  String get auditLog => 'Journal d\'audit';
  @override
  String get filterByDate => 'Filtrer par date';
  @override
  String get filterByUser => 'Filtrer par utilisateur';
  @override
  String get allUsers => 'Tous les utilisateurs';
  @override
  String get startDate => 'Date de début';
  @override
  String get endDate => 'Date de fin';
  @override
  String get action => 'Action';
  @override
  String get entity => 'Entité';
  @override
  String get timestamp => 'Horodatage';
  @override
  String get details => 'Détails';
  @override
  String get previous => 'Précédent';
  @override
  String get next => 'Suivant';
  @override
  String get user => 'Utilisateur';
  @override
  String get noAuditEntries => 'Aucune entrée d\'audit trouvée';
  @override
  String get profitReport => 'Rapport de bénéfices';
  @override
  String get netProfit => 'Bénéfice net';
  @override
  String get sessionCharges => 'Frais de séance';
  @override
  String get studentPayments => 'Paiements des élèves';
  @override
  String get selectMonth => 'Sélectionner le mois';
  @override
  String get selectYear => 'Sélectionner l\'année';
  @override
  String get month => 'Mois';
  @override
  String get year => 'Année';
  @override
  String get noStudentsFound => 'Aucun élève trouvé';
  @override
  String get studentCard => 'Carte d\'élève';
  @override
  String get studentCards => 'Cartes d\'élève';
  @override
  String get selectStudent => 'Sélectionner un élève';
  @override
  String get generateCard => 'Générer la carte';
  @override
  String get reissueCard => 'Réémettre la carte';
  @override
  String get confirmReissue => 'Confirmer la réémission';
  @override
  String get reissueConfirmMessage => 'Cela va révoquer la carte actuelle et en générer une nouvelle. Continuer ?';
  @override
  String get cardNotFound => 'Aucune carte active trouvée';
  @override
  String get cardRevoked => 'Carte révoquée';
  @override
  String get cardActive => 'Carte active';
  @override
  String get studentCode => 'Code élève';
  @override
  String get qrCode => 'Code QR';
  @override
  String get print => 'Imprimer';
  @override
  String get cardPreview => 'Aperçu de la carte';
  @override
  String get issuedDate => 'Date d\'émission';
  @override
  String get secureToken => 'Jeton sécurisé';
  @override
  String get barcode => 'Code-barres';
  @override
  String get student => 'Élève';
  @override
  String get debt => 'Dette';
  @override
  String get total => 'Total';
  @override
  String get outstandingDebtsList => 'Dettes impayées';
}
