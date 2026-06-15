import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../data.dart';
import '../model/comment_data_model.dart';

@Injectable()
class CommentDataMapper extends BaseDataMapper<CommentDataModel, Comment> with DataMapperMixin {
  @override
  Comment mapToEntity(CommentDataModel? data) {
    return Comment(
      id: data?.id ?? '',
      date: data?.date ?? DateTime.now(),
      title: data?.title ?? '',
      numberOfSubjects: data?.numberOfSubjects ?? 0,
      isNew: data?.isNew ?? false,
      content: data?.content ?? '',
    );
  }

  @override
  CommentDataModel mapToData(Comment entity) {
    return CommentDataModel(
      id: entity.id,
      date: entity.date,
      title: entity.title,
      numberOfSubjects: entity.numberOfSubjects,
      isNew: entity.isNew,
      content: entity.content,
    );
  }
}
