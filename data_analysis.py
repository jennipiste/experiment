import django
django.setup()

from experiment.api.models import Participant, ChatDialog, ChatMessage, Questionnaire, FinalQuestionnaire
import numpy

import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt


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


def get_dialogs_for_participants(participants):
    return ChatDialog.objects.filter(
        participant__in=participants
    )


def get_dialogs_in_condition(dialogs, condition):
    return dialogs.filter(experiment_condition=condition)


def get_answered_messages_count_in_dialogs(dialogs):
    question_messages = ChatMessage.objects.filter(
        chat_dialog__in=dialogs,
        type=2,
        sender_type=1,
    )
    answer_messages = ChatMessage.objects.filter(
        answer_to__in=question_messages
    )
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
        if first_message and second_message:
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
                wait_time_started_at = message.created_at
            elif message.type == 2 and message.sender_type == 2 and wait_time_started_at:
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
                wait_time_started_at = message.created_at
            elif message.type == 3 and message.sender_type == 2 and wait_time_started_at:
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
                wait_time_started_at = message.created_at
            elif message.type == 4 and message.sender_type == 2 and wait_time_started_at:
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


def draw_first_response_times():
    participants = get_participants(range(1, 25))
    dialogs = ChatDialog.objects.filter(participant__in=participants)
    a_dialogs = dialogs.filter(experiment_condition="A")
    b_dialogs = dialogs.filter(experiment_condition="B")
    c_dialogs = dialogs.filter(experiment_condition="C")
    d_dialogs = dialogs.filter(experiment_condition="D")

    a_wait_times = []
    for d in a_dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=d, type=1).order_by('created_at')
        wait_time_started_at = None
        for m in messages:
            if m.sender_type == 1:
                wait_time_started_at = m.created_at
            elif m.sender_type == 2:
                if wait_time_started_at:
                    wait_time = (m.created_at - wait_time_started_at).total_seconds()
                    a_wait_times.append(wait_time)

    b_wait_times = []
    for d in b_dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=d, type=1).order_by('created_at')
        wait_time_started_at = None
        for m in messages:
            if m.sender_type == 1:
                wait_time_started_at = m.created_at
            elif m.sender_type == 2:
                if wait_time_started_at:
                    wait_time = (m.created_at - wait_time_started_at).total_seconds()
                    b_wait_times.append(wait_time)

    c_wait_times = []
    for d in c_dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=d, type=1).order_by('created_at')
        wait_time_started_at = None
        for m in messages:
            if m.sender_type == 1:
                wait_time_started_at = m.created_at
            elif m.sender_type == 2:
                if wait_time_started_at:
                    wait_time = (m.created_at - wait_time_started_at).total_seconds()
                    c_wait_times.append(wait_time)


    d_wait_times = []
    for d in d_dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=d, type=1).order_by('created_at')
        wait_time_started_at = None
        for m in messages:
            if m.sender_type == 1:
                wait_time_started_at = m.created_at
            elif m.sender_type == 2:
                if wait_time_started_at:
                    wait_time = (m.created_at - wait_time_started_at).total_seconds()
                    d_wait_times.append(wait_time)

    mu_a = numpy.mean(a_wait_times)
    sigma_a = numpy.std(a_wait_times)
    mu_b = numpy.mean(b_wait_times)
    sigma_b = numpy.std(b_wait_times)
    mu_c = numpy.mean(c_wait_times)
    sigma_c = numpy.std(c_wait_times)
    mu_d = numpy.mean(d_wait_times)
    sigma_d = numpy.std(d_wait_times)

    # Histograms
    plt.figure()
    plt.title('First response time')

    # 3 chats
    ax1 = plt.subplot(2, 1, 1)
    ax1.set_title("3 simultaneous dialogs")
    ax1.set_xlabel('time (s)')
    ax1.set_ylabel('density')
    # Condition A
    n, bins_a, patches = ax1.hist(a_wait_times, 50, density=1)
    # Condition B
    n, bins_b, patches = ax1.hist(b_wait_times, 50, density=1)
    ax1.legend(('layout 1', 'layout 2'))

    # 4 chats
    ax2 = plt.subplot(2, 1, 2)
    ax2.set_title("4 simultaneous dialogs")
    ax2.set_xlabel('time (s)')
    ax2.set_ylabel('density')
    # Condition C
    n, bins_c, patches = ax2.hist(c_wait_times, 50, density=1)
    # Condition D
    n, bins_d, patches = ax2.hist(d_wait_times, 50, density=1)
    ax2.legend(('layout 1', 'layout 2'))

    plt.show()

    # Best fit lines
    plt.figure()
    plt.title('First response time')

    # 3 chats
    ax1 = plt.subplot(2, 1, 1)
    ax1.set_title("3 simultaneous dialogs")
    ax1.set_xlabel('time (s)')
    ax1.set_ylabel('density')
    # Condition A
    y_a = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_a)) * numpy.exp(-0.5 * (1 / sigma_a * (bins_a - mu_a))**2))
    ax1.plot(bins_a, y_a, '--')
    # Condition B
    y_b = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_b)) * numpy.exp(-0.5 * (1 / sigma_b * (bins_b - mu_b))**2))
    ax1.plot(bins_b, y_b, '--')
    ax1.legend(('layout 1', 'layout 2'))

    # 4 chats
    ax2 = plt.subplot(2, 1, 2)
    ax2.set_title("4 simultaneous dialogs")
    ax2.set_xlabel('time (s)')
    ax2.set_ylabel('density')
    # Condition C
    y_c = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_c)) * numpy.exp(-0.5 * (1 / sigma_c * (bins_c - mu_c))**2))
    ax2.plot(bins_c, y_c, '--')
    # Condition D
    y_d = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_d)) * numpy.exp(-0.5 * (1 / sigma_d * (bins_d - mu_d))**2))
    ax2.plot(bins_d, y_d, '--')
    ax2.legend(('layout 1', 'layout 2'))

    plt.show()


def draw_participant_first_response_times():
    participants = get_participants(range(1, 25))

    a_avg_wait_times = []
    b_avg_wait_times = []
    c_avg_wait_times = []
    d_avg_wait_times = []
    for p in participants:
        dialogs = ChatDialog.objects.filter(participant=p)

        a_wait_times = []
        a_dialogs = dialogs.filter(experiment_condition="A")
        for d in a_dialogs:
            messages = ChatMessage.objects.filter(chat_dialog=d, type=1).order_by('created_at')
            wait_time_started_at = None
            for m in messages:
                if m.sender_type == 1:
                    wait_time_started_at = m.created_at
                elif m.sender_type == 2:
                    if wait_time_started_at:
                        wait_time = (m.created_at - wait_time_started_at).total_seconds()
                        a_wait_times.append(wait_time)
        a_avg_wait_times.append(numpy.mean(a_wait_times))

        b_wait_times = []
        b_dialogs = dialogs.filter(experiment_condition="B")
        for d in b_dialogs:
            messages = ChatMessage.objects.filter(chat_dialog=d, type=1).order_by('created_at')
            wait_time_started_at = None
            for m in messages:
                if m.sender_type == 1:
                    wait_time_started_at = m.created_at
                elif m.sender_type == 2:
                    if wait_time_started_at:
                        wait_time = (m.created_at - wait_time_started_at).total_seconds()
                        b_wait_times.append(wait_time)
        b_avg_wait_times.append(numpy.mean(b_wait_times))

        c_wait_times = []
        c_dialogs = dialogs.filter(experiment_condition="C")
        for d in c_dialogs:
            messages = ChatMessage.objects.filter(chat_dialog=d, type=1).order_by('created_at')
            wait_time_started_at = None
            for m in messages:
                if m.sender_type == 1:
                    wait_time_started_at = m.created_at
                elif m.sender_type == 2:
                    if wait_time_started_at:
                        wait_time = (m.created_at - wait_time_started_at).total_seconds()
                        c_wait_times.append(wait_time)
        c_avg_wait_times.append(numpy.mean(c_wait_times))

        d_wait_times = []
        d_dialogs = dialogs.filter(experiment_condition="D")
        for d in d_dialogs:
            messages = ChatMessage.objects.filter(chat_dialog=d, type=1).order_by('created_at')
            wait_time_started_at = None
            for m in messages:
                if m.sender_type == 1:
                    wait_time_started_at = m.created_at
                elif m.sender_type == 2:
                    if wait_time_started_at:
                        wait_time = (m.created_at - wait_time_started_at).total_seconds()
                        d_wait_times.append(wait_time)
        d_avg_wait_times.append(numpy.mean(d_wait_times))

    # Subplots
    plt.figure()
    plt.title('Average first response times for participants')
    # 3 chats
    ax1 = plt.subplot(2, 1, 1)
    ax1.set_title("3 simultaneous dialogs")
    ax1.set_xlabel('participant')
    ax1.set_ylabel('time (s)')
    # Condition A
    ax1.plot(range(1, 25), a_avg_wait_times)
    # Condition B
    ax1.plot(range(1, 25), b_avg_wait_times)
    ax1.legend(('layout 1', 'layout 2'))
    # 4 chats
    ax2 = plt.subplot(2, 1, 2)
    ax2.set_title("4 simultaneous dialogs")
    ax2.set_xlabel('participant')
    ax2.set_ylabel('time (s)')
    # Condition C
    ax2.plot(range(1, 25), c_avg_wait_times)
    # Condition D
    ax2.plot(range(1, 25), d_avg_wait_times)
    ax2.legend(('layout 1', 'layout 2'))
    plt.show()

    # Same plot, sorted
    plt.figure()
    plt.title('Average first response times')
    plt.xlabel('participant')
    plt.ylabel('time (s)')
    # Condition A
    plt.plot(range(1, 25), sorted(a_avg_wait_times))
    # Condition B
    plt.plot(range(1, 25), sorted(b_avg_wait_times))
    # Condition C
    plt.plot(range(1, 25), sorted(c_avg_wait_times))
    # Condition D
    plt.plot(range(1, 25), sorted(d_avg_wait_times))
    plt.legend(('A', 'B', 'C', 'D'))
    plt.show()

    # Bar plot
    N = 24
    ind = numpy.arange(N)
    width = 0.2
    plt.figure()
    plt.title('Average first response times for participants')
    plt.xlabel('participant')
    plt.ylabel('time (s)')
    # Condition A
    plt.bar(ind, a_avg_wait_times, width)
    # Condition B
    plt.bar(ind + width, b_avg_wait_times, width)
    # Condition C
    plt.bar(ind + width * 2, c_avg_wait_times, width)
    # Condition D
    plt.bar(ind + width * 3, d_avg_wait_times, width)
    plt.legend(('A', 'B', 'C', 'D'))
    plt.show()

    # Bar plot, sorted
    N = 24
    ind = numpy.arange(N)
    width = 0.2
    plt.figure()
    plt.title('Average first response times for participants')
    plt.xlabel('participant')
    plt.ylabel('time (s)')
    # Condition A
    plt.bar(ind, sorted(a_avg_wait_times), width)
    # Condition B
    plt.bar(ind + width, sorted(b_avg_wait_times), width)
    # Condition C
    plt.bar(ind + width * 2, sorted(c_avg_wait_times), width)
    # Condition D
    plt.bar(ind + width * 3, sorted(d_avg_wait_times), width)
    plt.legend(('A', 'B', 'C', 'D'))
    plt.show()


def draw_question_response_times():
    participants = get_participants(range(1, 25))
    dialogs = ChatDialog.objects.filter(participant__in=participants)
    a_dialogs = dialogs.filter(experiment_condition="A")
    b_dialogs = dialogs.filter(experiment_condition="B")
    c_dialogs = dialogs.filter(experiment_condition="C")
    d_dialogs = dialogs.filter(experiment_condition="D")

    a_wait_times = []
    for d in a_dialogs:
        questions = ChatMessage.objects.filter(chat_dialog=d, type=2, sender_type=1).order_by('created_at')
        wait_time_started_at = None
        for q in questions:
            wait_time_started_at = q.created_at
            responses = ChatMessage.objects.filter(answer_to=q)
            if responses:
                wait_time = (responses.latest('created_at').created_at - wait_time_started_at).total_seconds()
                a_wait_times.append(wait_time)
                responses = []

    b_wait_times = []
    for d in b_dialogs:
        questions = ChatMessage.objects.filter(chat_dialog=d, type=2, sender_type=1).order_by('created_at')
        wait_time_started_at = None
        for q in questions:
            wait_time_started_at = q.created_at
            responses = ChatMessage.objects.filter(answer_to=q)
            if responses:
                wait_time = (responses.latest('created_at').created_at - wait_time_started_at).total_seconds()
                b_wait_times.append(wait_time)
                responses = []

    c_wait_times = []
    for d in c_dialogs:
        questions = ChatMessage.objects.filter(chat_dialog=d, type=2, sender_type=1).order_by('created_at')
        wait_time_started_at = None
        for q in questions:
            wait_time_started_at = q.created_at
            responses = ChatMessage.objects.filter(answer_to=q)
            if responses:
                wait_time = (responses.latest('created_at').created_at - wait_time_started_at).total_seconds()
                c_wait_times.append(wait_time)
                responses = []


    d_wait_times = []
    for d in d_dialogs:
        questions = ChatMessage.objects.filter(chat_dialog=d, type=2, sender_type=1).order_by('created_at')
        wait_time_started_at = None
        for q in questions:
            wait_time_started_at = q.created_at
            responses = ChatMessage.objects.filter(answer_to=q)
            if responses:
                wait_time = (responses.latest('created_at').created_at - wait_time_started_at).total_seconds()
                d_wait_times.append(wait_time)
                responses = []

    mu_a = numpy.mean(a_wait_times)
    sigma_a = numpy.std(a_wait_times)
    mu_b = numpy.mean(b_wait_times)
    sigma_b = numpy.std(b_wait_times)
    mu_c = numpy.mean(c_wait_times)
    sigma_c = numpy.std(c_wait_times)
    mu_d = numpy.mean(d_wait_times)
    sigma_d = numpy.std(d_wait_times)

    # Histograms
    plt.figure()
    plt.title('Question response time')

    # 3 chats
    ax1 = plt.subplot(2, 1, 1)
    ax1.set_title("3 simultaneous dialogs")
    ax1.set_xlabel('time (s)')
    ax1.set_ylabel('density')
    # Condition A
    n, bins_a, patches = ax1.hist(a_wait_times, 50, density=1)
    # Condition B
    n, bins_b, patches = ax1.hist(b_wait_times, 50, density=1)
    ax1.legend(('layout 1', 'layout 2'))

    # 4 chats
    ax2 = plt.subplot(2, 1, 2)
    ax2.set_title("4 simultaneous dialogs")
    ax2.set_xlabel('time (s)')
    ax2.set_ylabel('density')
    # Condition C
    n, bins_c, patches = ax2.hist(c_wait_times, 50, density=1)
    # Condition D
    n, bins_d, patches = ax2.hist(d_wait_times, 50, density=1)
    ax2.legend(('layout 1', 'layout 2'))

    plt.show()

    # Best fit lines
    plt.figure()
    plt.title('Question response time')

    # 3 chats
    ax1 = plt.subplot(2, 1, 1)
    ax1.set_title("3 simultaneous dialogs")
    ax1.set_xlabel('time (s)')
    ax1.set_ylabel('density')
    # Condition A
    y_a = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_a)) * numpy.exp(-0.5 * (1 / sigma_a * (bins_a - mu_a))**2))
    ax1.plot(bins_a, y_a, '--')
    # Condition B
    y_b = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_b)) * numpy.exp(-0.5 * (1 / sigma_b * (bins_b - mu_b))**2))
    ax1.plot(bins_b, y_b, '--')
    ax1.legend(('layout 1', 'layout 2'))

    # 4 chats
    ax2 = plt.subplot(2, 1, 2)
    ax2.set_title("4 simultaneous dialogs")
    ax2.set_xlabel('time (s)')
    ax2.set_ylabel('density')
    # Condition C
    y_c = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_c)) * numpy.exp(-0.5 * (1 / sigma_c * (bins_c - mu_c))**2))
    ax2.plot(bins_c, y_c, '--')
    # Condition D
    y_d = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_d)) * numpy.exp(-0.5 * (1 / sigma_d * (bins_d - mu_d))**2))
    ax2.plot(bins_d, y_d, '--')
    ax2.legend(('layout 1', 'layout 2'))

    plt.show()


def draw_reaction_times():
    participants = get_participants(range(1, 25))
    dialogs = ChatDialog.objects.filter(participant__in=participants)
    a_dialogs = dialogs.filter(experiment_condition="A")
    b_dialogs = dialogs.filter(experiment_condition="B")
    c_dialogs = dialogs.filter(experiment_condition="C")
    d_dialogs = dialogs.filter(experiment_condition="D")

    a_wait_times = []
    for d in a_dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=d).order_by('created_at')
        wait_time_started_at = None
        for m in messages:
            wait_time_started_at = m.created_at
            responses = ChatMessage.objects.filter(answer_to=m)
            if responses:
                wait_time = (responses.latest('created_at').created_at - wait_time_started_at).total_seconds()
                a_wait_times.append(wait_time)
                responses = []

    b_wait_times = []
    for d in b_dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=d).order_by('created_at')
        wait_time_started_at = None
        for m in messages:
            wait_time_started_at = m.created_at
            responses = ChatMessage.objects.filter(answer_to=m)
            if responses:
                wait_time = (responses.latest('created_at').created_at - wait_time_started_at).total_seconds()
                b_wait_times.append(wait_time)
                responses = []

    c_wait_times = []
    for d in c_dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=d).order_by('created_at')
        wait_time_started_at = None
        for m in messages:
            wait_time_started_at = m.created_at
            responses = ChatMessage.objects.filter(answer_to=m)
            if responses:
                wait_time = (responses.latest('created_at').created_at - wait_time_started_at).total_seconds()
                c_wait_times.append(wait_time)
                responses = []


    d_wait_times = []
    for d in d_dialogs:
        messages = ChatMessage.objects.filter(chat_dialog=d).order_by('created_at')
        wait_time_started_at = None
        for m in messages:
            wait_time_started_at = m.created_at
            responses = ChatMessage.objects.filter(answer_to=m)
            if responses:
                wait_time = (responses.latest('created_at').created_at - wait_time_started_at).total_seconds()
                d_wait_times.append(wait_time)
                responses = []

    mu_a = numpy.mean(a_wait_times)
    sigma_a = numpy.std(a_wait_times)
    mu_b = numpy.mean(b_wait_times)
    sigma_b = numpy.std(b_wait_times)
    mu_c = numpy.mean(c_wait_times)
    sigma_c = numpy.std(c_wait_times)
    mu_d = numpy.mean(d_wait_times)
    sigma_d = numpy.std(d_wait_times)

    # Histograms
    plt.figure()
    plt.title('Question response time')

    # 3 chats
    ax1 = plt.subplot(2, 1, 1)
    ax1.set_title("3 simultaneous dialogs")
    ax1.set_xlabel('time (s)')
    ax1.set_ylabel('density')
    # Condition A
    n, bins_a, patches = ax1.hist(a_wait_times, 50, density=1)
    # Condition B
    n, bins_b, patches = ax1.hist(b_wait_times, 50, density=1)
    ax1.legend(('layout 1', 'layout 2'))

    # 4 chats
    ax2 = plt.subplot(2, 1, 2)
    ax2.set_title("4 simultaneous dialogs")
    ax2.set_xlabel('time (s)')
    ax2.set_ylabel('density')
    # Condition C
    n, bins_c, patches = ax2.hist(c_wait_times, 50, density=1)
    # Condition D
    n, bins_d, patches = ax2.hist(d_wait_times, 50, density=1)
    ax2.legend(('layout 1', 'layout 2'))

    plt.show()

    # Best fit lines
    plt.figure()
    plt.title('Question response time')

    # 3 chats
    ax1 = plt.subplot(2, 1, 1)
    ax1.set_title("3 simultaneous dialogs")
    ax1.set_xlabel('time (s)')
    ax1.set_ylabel('density')
    # Condition A
    y_a = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_a)) * numpy.exp(-0.5 * (1 / sigma_a * (bins_a - mu_a))**2))
    ax1.plot(bins_a, y_a, '--')
    # Condition B
    y_b = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_b)) * numpy.exp(-0.5 * (1 / sigma_b * (bins_b - mu_b))**2))
    ax1.plot(bins_b, y_b, '--')
    ax1.legend(('layout 1', 'layout 2'))

    # 4 chats
    ax2 = plt.subplot(2, 1, 2)
    ax2.set_title("4 simultaneous dialogs")
    ax2.set_xlabel('time (s)')
    ax2.set_ylabel('density')
    # Condition C
    y_c = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_c)) * numpy.exp(-0.5 * (1 / sigma_c * (bins_c - mu_c))**2))
    ax2.plot(bins_c, y_c, '--')
    # Condition D
    y_d = ((1 / (numpy.sqrt(2 * numpy.pi) * sigma_d)) * numpy.exp(-0.5 * (1 / sigma_d * (bins_d - mu_d))**2))
    ax2.plot(bins_d, y_d, '--')
    ax2.legend(('layout 1', 'layout 2'))

    plt.show()