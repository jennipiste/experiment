# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from rest_framework import generics

from experiment.api.models import Participant, ChatDialog, ChatMessage
from experiment.api.serializers import ParticipantSerializer, ChatDialogSerializer, ChatMessageSerializer


class ParticipantListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = ParticipantSerializer
    queryset = Participant.objects.all()


class ChatMessageListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = ChatMessageSerializer
    queryset = ChatMessage.objects.all()


class ChatDialogListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = ChatDialogSerializer
    queryset = ChatDialog.objects.all()
