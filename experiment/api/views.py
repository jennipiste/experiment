# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.utils import timezone
from rest_framework import generics
from rest_framework import status
from rest_framework.response import Response
from rest_framework.exceptions import NotFound

from experiment.api.models import Participant, ChatDialog, ChatMessage
from experiment.api.serializers import ParticipantSerializer, ChatDialogSerializer, ChatMessageSerializer


class ParticipantListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = ParticipantSerializer
    queryset = Participant.objects.all()

    def create(self, request, *args, **kwargs):
        name = request.data.get('name')
        # Check if participant already exists
        try:
            participant = Participant.objects.get(name=name)
            response_status = status.HTTP_200_OK
        except Participant.DoesNotExist:
            latest_group = Participant.objects.latest('created_at').group
            participant = Participant.objects.create(
                name=name,
                group=1 if not latest_group or latest_group==2 else 2
            )
            response_status = status.HTTP_201_CREATED
        serializer = self.get_serializer(participant, data=request.data, partial=False)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=response_status)


class ParticipantChatDialogListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = ChatDialogSerializer
    queryset = ChatDialog.objects.all()

    def initial(self, *args, **kwargs):
        super(ParticipantChatDialogListCreateAPIView, self).initial(*args, **kwargs)
        participant_id = self.kwargs['participant_id']
        try:
            self.participant = Participant.objects.get(id=participant_id)
        except Participant.DoesNotExist:
            raise NotFound("Participant not found")

    def get_queryset(self):
        queryset = super(ParticipantChatDialogListCreateAPIView, self).get_queryset()
        return queryset.filter(participant=self.participant)

    def create(self, request, *args, **kwargs):
        # Create every second participant to group 1 and every second to group 2
        dialog = ChatDialog.objects.create(
            name=request.data.get('name'),
            subject=request.data.get('subject'),
            participant=self.participant,
        )
        return Response(self.get_serializer(dialog).data, status=status.HTTP_201_CREATED)


class ChatDialogUpdateAPIView(generics.UpdateAPIView):
    serializer_class = ChatDialogSerializer
    queryset = ChatDialog.objects.all()
    lookup_field = 'id'
    lookup_url_kwarg = 'dialog_id'

    def update(self, request, *args, **kwargs):
        dialog_id = self.kwargs['dialog_id']
        try:
            dialog = ChatDialog.objects.get(id=dialog_id)
        except ChatDialog.DoesNotExist:
            raise NotFound("Dialog not found")

        data = request.data
        if 'is_ended' in data:
            data['ended_at'] = timezone.now()

        if 'is_closed' in data:
            data['closed_at'] = timezone.now()

        serializer = self.get_serializer(dialog, data=data, partial=True)
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)


class ParticipantChatMessageListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = ChatMessageSerializer
    queryset = ChatMessage.objects.all()

    def initial(self, *args, **kwargs):
        super(ParticipantChatMessageListCreateAPIView, self).initial(*args, **kwargs)
        participant_id = self.kwargs['participant_id']
        dialog_id = self.kwargs['dialog_id']
        try:
            self.participant = Participant.objects.get(id=participant_id)
        except Participant.DoesNotExist:
            raise NotFound("Participant not found")
        else:
            try:
                self.dialog = ChatDialog.objects.get(id=dialog_id, participant=self.participant)
            except ChatDialog.DoesNotExist:
                raise NotFound("Dialog for participant not found")

    def get_queryset(self):
        queryset = super(ParticipantChatMessageListCreateAPIView, self).get_queryset()
        return queryset.filter(chat_dialog=self.dialog)

    def create(self, request, *args, **kwargs):
        try:
            latest_question = ChatMessage.objects.filter(type=1, chat_dialog=self.dialog).latest('created_at')
        except ChatMessage.DoesNotExist:
            latest_question = None

        message = ChatMessage.objects.create(
            message=request.data.get('message'),
            sender=self.participant,
            type=2,
            chat_dialog=self.dialog,
            answer_to=latest_question,
        )
        return Response(self.get_serializer(message).data, status=status.HTTP_201_CREATED)


class ChatMessageListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = ChatMessageSerializer
    queryset = ChatMessage.objects.all()

    def initial(self, *args, **kwargs):
        super(ChatMessageListCreateAPIView, self).initial(*args, **kwargs)
        dialog_id = self.kwargs['dialog_id']
        try:
            self.dialog = ChatDialog.objects.get(id=dialog_id)
        except ChatDialog.DoesNotExist:
            raise NotFound("Dialog for participant not found")

    def get_queryset(self):
        queryset = super(ChatMessageListCreateAPIView, self).get_queryset()
        return queryset.filter(chat_dialog=self.dialog)

    def create(self, request, *args, **kwargs):
        message = ChatMessage.objects.create(
            message=request.data.get('message'),
            sender=None,
            type=1,
            chat_dialog=self.dialog,
        )
        return Response(self.get_serializer(message).data, status=status.HTTP_201_CREATED)
