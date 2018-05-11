# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from rest_framework import serializers
from experiment.api.models import ChatDialog, ChatMessage, Participant


class ParticipantSerializer(serializers.ModelSerializer):
    class Meta:
        model = Participant
        fields = [
            'id',
            'name',
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
            'created_at',
            'is_ended',
            'ended_at',
            'is_closed',
            'closed_at',
        ]


class ChatMessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = ChatMessage
        fields = [
            'id',
            'message',
            'sender',
            'type',
            'chat_dialog',
            'answer_to',
            'created_at',
        ]
