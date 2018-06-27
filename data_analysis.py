import django
django.setup()

from experiment.api.models import Participant, ChatDialog, ChatMessage, Questionnaire, FinalQuestionnaire
import numpy


def get_participant(participant_number):
    return Participant.objects.get(number=participant_number)


def get_participants(participant_numbers):
    return Participant.objects.filter(number__in=participant_numbers)


def get_participant_dialogs(participant):
    return ChatDialog.objects.filter(participant=participant)


def get_participant_dialogs_in_condition(participant, condition):
    return ChatDialog.objects.filter(
        participant=participant,
        experiment_condition=condition,
    )


def get_participant_dialogs_in_part(participant, part):
    return ChatDialog.objects.filter(
        participant=participant,
        experiment_part=part,
    )


def get_ended_dialogs(dialogs):
    return dialogs.filter(is_ended=True)


def get_answered_messages_count_in_dialogs(dialogs):
    question_messages = ChatMessage.objects.filter(
        chat_dialog__in=dialogs,
        type=2,
        sender_type=1,
    )
    for question_message in question_messages:
        print question_message.message
    print "=============================================="
    answer_messages = ChatMessage.objects.filter(
        answer_to__in=question_messages
    )
    for answer_message in answer_messages:
        print answer_message.message
    return answer_messages.count()


def get_first_response_wait_times_in_dialogs(dialogs):
    wait_times = []
    for dialog in dialogs:
        first_message = ChatMessage.objects.get(
            sender_type=1,
            type=1,
            chat_dialog=dialog,
        )
        second_message = ChatMessage.objects.filter(
            sender_type=2,
            type=1,
            chat_dialog=dialog,
        ).first()
        wait_time = (second_message.created_at - first_message.created_at).total_seconds()
        wait_times.append(wait_time)
    return wait_times


def get_overall_reaction_times_in_dialogs(dialogs):
    wait_times = []
    for dialog in dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=dialog).order_by('created_at')
        wait_time_started_at = None
        for message in messages:
            if message.sender_type == 1 and not wait_time_started_at:
                wait_time_started_at = message.created_at
            elif message.sender_type == 2 and wait_time_started_at:
                wait_time = (message.created_at - wait_time_started_at).total_seconds()
                wait_times.append(wait_time)
                wait_time_started_at = None
    return wait_times


def get_question_message_wait_times_in_dialogs(dialogs):
    wait_times = []
    for dialog in dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=dialog).order_by('created_at')
        wait_time_started_at = None
        for message in messages:
            # Check only question type messages
            if message.type == 2 and message.sender_type == 1 and not wait_time_started_at:
                print "1", message.message
                wait_time_started_at = message.created_at
            elif message.type == 2 and message.sender_type == 2 and wait_time_started_at:
                print "2", message.message
                wait_time = (message.created_at - wait_time_started_at).total_seconds()
                wait_times.append(wait_time)
                wait_time_started_at = None
    return wait_times


def get_are_you_there_wait_times_in_dialogs(dialogs):
    wait_times = []
    for dialog in dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=dialog).order_by('created_at')
        wait_time_started_at = None
        for message in messages:
            # Check only question type messages
            if message.type == 3 and message.sender_type == 1 and not wait_time_started_at:
                print "1", message.message
                wait_time_started_at = message.created_at
            elif message.type == 3 and message.sender_type == 2 and wait_time_started_at:
                print "2", message.message
                wait_time = (message.created_at - wait_time_started_at).total_seconds()
                wait_times.append(wait_time)
                wait_time_started_at = None
    return wait_times


def get_thanks_message_wait_times_in_dialogs(dialogs):
    wait_times = []
    for dialog in dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=dialog).order_by('created_at')
        wait_time_started_at = None
        for message in messages:
            # Check only question type messages
            if message.type == 4 and message.sender_type == 1 and not wait_time_started_at:
                print "1", message.message
                wait_time_started_at = message.created_at
            elif message.type == 4 and message.sender_type == 2 and wait_time_started_at:
                print "2", message.message
                wait_time = (message.created_at - wait_time_started_at).total_seconds()
                wait_times.append(wait_time)
                wait_time_started_at = None
    return wait_times


def get_average_wait_time(wait_times):
    return numpy.mean(wait_times)


def get_median_wait_time(wait_times):
    return numpy.median(wait_times)


def get_std_wait_time(wait_times):
    return numpy.std(wait_times)


def get_max_wait_time(wait_times):
    return numpy.max(wait_times)


def get_min_wait_time(wait_times):
    return numpy.min(wait_times)


def main():
    print "ASD"


if __name__ == '__main__':
    main()

