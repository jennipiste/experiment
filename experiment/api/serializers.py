# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from rest_framework import serializers
from experiment.api.models import ChatDialog, ChatMessage, Participant, Questionnaire, FinalQuestionnaire


class ParticipantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Participant
        fields = [
            'id',
            'group',
            'number',
            'created_at',
        ]


class ChatDialogSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChatDialog
        fields = [
            'id',
            'name',
            'subject',
            'participant',
            'experiment_part',
            'experiment_condition',
            'created_at',
            'created_after_experiment_part_started',
            'is_ended',
            'ended_at',
        ]


class ChatMessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChatMessage
        fields = [
            'id',
            'message',
            'sender',
            'sender_type',
            'type',
            'chat_dialog',
            'answer_to',
            'created_at',
            'created_after_experiment_part_started',
        ]


class QuestionnaireSerializer(serializers.ModelSerializer):
    class Meta:
        model = Questionnaire
        fields = [
            'id',
            'participant',
            'experiment_part',
            'experiment_condition',
            'q1',
            'q2',
            'q3',
            'q4',
            'q5',
            'created_at',
        ]


class FinalQuestionnaireSerializer(serializers.ModelSerializer):
    class Meta:
        model = FinalQuestionnaire
        fields = [
            'id',
            'participant',
            'q1',
            'q2',
            'q3',
            'created_at',
        ]
