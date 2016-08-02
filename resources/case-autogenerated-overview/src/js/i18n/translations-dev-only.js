(function () {
    'use strict';

    angular.module('caseOverview').requires.push('translationsDevMode'); // Make main module depends on the mocked APIs

    /* Make the module depends on a Mock Backend to simulate API calls. */
    var app = angular.module('translationsDevMode', ['ngMockE2E']);



    // define mock answers coming from the backend
    app.run(function($httpBackend) {
        console.log('**********************************************************************************************');
        console.log('*********************** YOU ARE USING MOCK IMPLEMENTATION OF BACKEND!  ***********************');
        console.log('*********************** This is for development only. If you can read  ***********************');
        console.log('*********************** this message and are not in development        ***********************');
        console.log('*********************** environment, please report a bug.              ***********************');
        console.log('*********************** FRENCH Translations                            ***********************');
        console.log('**********************************************************************************************');

        //--------------------------------------------------------------
        //-------------------- French Translations----------------------
        //--------------------------------------------------------------
        var french = [{
            'value': 'Project-Id-Version: bonita-bpm-new-features\nReport-Msgid-Bugs-To: \nPOT-Creation-Date: 2015-02-12 02:01+0100\nPO-Revision-Date: 2015-05-04 04:41-0400\nLast-Translator: charlessouillard <rodrigue.legall@bonitasoft.com>\nLanguage-Team: French\nLanguage: fr_FR\nMIME-Version: 1.0\nContent-Type: text/plain; charset=UTF-8\nContent-Transfer-Encoding: 8bit\nPlural-Forms: nplurals=2; plural=(n > 1);\nX-Generator: crowdin.com\nX-Crowdin-Project: bonita-bpm-new-features\nX-Crowdin-Language: fr\nX-Crowdin-File: /master/bonita-web-sp/portal/portal-sp.po\n',
            'key': ''
        }, {
            'value': 'Données métier',
            'key': 'Business data'
        }, {
            'value': 'Aucune donnée liée à ce cas.',
            'key': 'No business data used in this case.'
        }, {
            'value': 'Fichiers joints',
            'key': 'Documents'
        }, {
            'value': 'Identifiant',
            'key': 'Name'
        }, {
            'value': 'Fichier',
            'key': 'Filename'
        }, {
            'value': 'Télécharger',
            'key': 'Download'
        }, {
            'value': 'Aucune pièce jointe.',
            'key': 'No Documents used in this case.'
        }, {
            'value': 'Vue temporelle',
            'key': 'Timeline'
        }, {
            'value': 'Aucune tâche réalisée pour le moment.',
            'key': 'No tasks executed yet.'
        }, {
            'value': 'Taches réalisées par tous les participants',
            'key': 'Tasks executed by any participant will be displayed here ordered by date. Most recent on the top.'
        }, {
            'value': 'Identifiant du cas: {{case.caseIdToDisplay}} - Processus: {{case.processDefinitionId.displayName}}',
            'key': 'Case id:{{case.caseIdToDisplay}} - Process: {{case.processDefinitionId.displayName}}'
        }, {
            'value': 'Cas démarré par: {{case.started_by.firstname}} {{case.started_by.lastname}}',
            'key': 'Case started by: {{case.started_by.firstname}} {{case.started_by.lastname}}'
        }, {
            'value': 'Liste de {{ dataType }}',
            'key': 'List of {{ dataType }}'
        }];

        $httpBackend.whenGET('../API/system/i18ntranslation?f=locale%3Dfr').respond(french);
        $httpBackend.whenGET('../API/system/i18ntranslation?f=locale%3Den').respond(function() {
            console.log('Getting french translations for english');
            return [200, [], {}];
        });
        //-----------------------------------------------------------------------------------
    });
})();

