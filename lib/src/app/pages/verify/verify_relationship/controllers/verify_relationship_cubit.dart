import 'package:equatable/equatable.dart';

import '../../../../../utils/export/logic_export.dart';

part 'verify_relationship_state.dart';

class VerifyRelationshipCubit extends BaseCubit<VerifyRelationshipState> {
  VerifyRelationshipCubit(this.repo, this.relationshipModel)
      : super(const VerifyRelationshipState());
  final IUserInfoRepo repo;
  RelationshipInformationModel? relationshipModel;

  loadRelationData() async {
    emit(state.copyWith(type: CallDataApiType.get));
    if (relationshipModel != null) {
      final either = await repo
          .getRelationshipInformation(relationshipModel!.relationshipId!);
      either.fold((failure) {
        log(failure.toString());
        emit(state.copyWith(type: CallDataApiType.create));
      }, (data) {
        relationshipModel = data;
        emit(state.copyWith(
          relationship: data.relationship,
          phone: data.phone,
          fullName: data.name,
          type: CallDataApiType.update,
        ));
      });
    } else {
      emit(state.copyWith(type: CallDataApiType.create));
    }
  }

  createVerifyEvent() async {
    if (state.type == CallDataApiType.update && relationshipModel != null) {
      if (isEqualWithStateData(state)) {
        log('not update');
        emit(state.copyWith(relationshipModel: relationshipModel));
      } else {
        emitWaiting(true);
        final result = await repo.updateRelationshipInformation(
          id: relationshipModel!.relationshipId!,
          phone: state.phone,
          name: state.fullName,
          relationship: state.relationship,
        );
        emitWaiting(false);
        result.fold((failure) {
          log(failure.toString());
          emitError(failure);
        }, (data) {
          emit(state.copyWith(relationshipModel: data));
        });
      }
    } else {
      emitWaiting(true);
      final result = await repo.createRelationshipInformation(
        relationship: state.relationship!,
        phone: state.phone!,
        name: state.fullName!,
      );
      emitWaiting(false);
      result.fold((failure) {
        log(failure.toString());
      }, (data) {
        emit(state.copyWith(relationshipModel: data));
      });
    }
  }

  deleteRelationship() async {
    emitWaiting(true);
    final result = await repo.deleteRelationshipInformation(
      relationshipModel!.relationshipId!,
    );
    emitWaiting(false);
    result.fold((failure) {
      log(failure.toString());
    }, (data) {
      emit(state.copyWith(relationshipModel: relationshipModel));
    });
  }

  updateFormField({
    String? fullName,
    String? phone,
    Relationship? relationship,
    RelationshipInformationModel? relationshipModel,
  }) {
    emit(
      state.copyWith(
        fullName: fullName,
        phone: phone,
        relationship: relationship,
        relationshipModel: relationshipModel,
      ),
    );
  }

  bool isEqualWithStateData(VerifyRelationshipState state) {
    if (relationshipModel!.phone == state.phone &&
        relationshipModel!.relationship == state.relationship &&
        relationshipModel!.name == state.fullName) {
      return true;
    }
    return false;
  }
}
